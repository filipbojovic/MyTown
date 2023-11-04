using System;
using System.Collections.Concurrent;
using System.Linq;
using System.Net.WebSockets;
using System.Threading;
using System.Threading.Tasks;

namespace mytown.SocketData
{
    public class WebSocketConnectionManager
    {
        private ConcurrentDictionary<string, WebSocket> _socketConnection = new ConcurrentDictionary<string, WebSocket>();
        public void AddSocket(WebSocket socket, string userSocketID)
        {
            string socketId = userSocketID; // CreateConnectionId();
            while (!_socketConnection.TryAdd(socketId, socket))
            {
                socketId = userSocketID; // CreateConnectionId();
            }
        }
        public async Task RemoveSocket(string id)
        {
            try
            {
                WebSocket socket;
                _socketConnection.TryRemove(id, out socket);
                await socket.CloseOutputAsync(WebSocketCloseStatus.NormalClosure, null, CancellationToken.None);
            }
            catch (Exception)
            {
            }
        }
        public WebSocket GetSocketById(string id)
        {
            return _socketConnection.FirstOrDefault(m => m.Key == id).Value;
        }
        public ConcurrentDictionary<string, WebSocket> GetAll()
        {
            return _socketConnection;
        }
        public string GetSocketId(WebSocket socket)
        {
            return _socketConnection.FirstOrDefault(m => m.Value == socket).Key;
        }
        private string CreateConnectionId()
        {
            return Guid.NewGuid().ToString();
        }
    }
}
