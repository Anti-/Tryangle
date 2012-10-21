namespace Tryangle {
	
	class Client : ClientBase {
		
		public Client(GLib.Socket objSocket){
			this.objSocket = objSocket;
			this.objSocket.set_blocking(false);
		}
		
	}
	
}
