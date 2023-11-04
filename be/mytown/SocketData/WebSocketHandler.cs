using Newtonsoft.Json.Linq;
using System.Net.WebSockets;
using System.Text;
using System.Threading.Tasks;

namespace mytown.SocketData
{
    public abstract class WebSocketHandler
    {
        public WebSocketConnectionManager WebSocketConnectionManager { get; set; }
        public WebSocketHandler(WebSocketConnectionManager webSocketConnectionManager)
        {
            WebSocketConnectionManager = webSocketConnectionManager;
        }
        public virtual async Task OnConnected(WebSocket socket, string socketID)
        {
            var oldSocket = WebSocketConnectionManager.GetSocketById(socketID);
            if (oldSocket != null)
                await WebSocketConnectionManager.RemoveSocket(socketID);

            WebSocketConnectionManager.AddSocket(socket, socketID);
        }
        public virtual async Task OnDisconnected(WebSocket socket)
        {
            var id = WebSocketConnectionManager.GetSocketId(socket);
            await WebSocketConnectionManager.RemoveSocket(id);
        }
        public async Task SendMessageAsync(WebSocket socket, JObject message)
        {
            if (socket == null || socket.State != WebSocketState.Open)
                return;
            await socket.SendAsync(
            buffer: Encoding.UTF8.GetBytes(message.ToString()),
            messageType: WebSocketMessageType.Text,
            endOfMessage: true,
            cancellationToken: System.Threading.CancellationToken.None);
        }
        public async Task SendMessageAsync(string socketId, JObject message)
        {
            await SendMessageAsync(WebSocketConnectionManager.GetSocketById(socketId), message);
        }
        public async Task SendMessageToAllAsync(JObject message)
        {
            foreach (var pair in WebSocketConnectionManager.GetAll())
            {
                if (pair.Value.State == WebSocketState.Open)
                    await SendMessageAsync(pair.Value, message);
            }
        }
        public abstract Task ReceiveAsync(WebSocket socket, WebSocketReceiveResult result, byte[] buffer);
    }
}
