namespace Tryangle {
	
	abstract class ClientBase : GLib.Object {
		
		public GLib.DataInputStream objDataInput;
		public GLib.DataOutputStream objDataOutput;
		public GLib.SocketConnection objSocketConnection;
		
	}
	
}
