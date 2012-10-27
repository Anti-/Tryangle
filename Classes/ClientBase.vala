namespace Tryangle {
	
	abstract class ClientBase : GLib.Object {
		
		public GLib.Socket objSocket;
		
		public virtual void sendPacket(string strPacket){
			try {
				this.objSocket.send(strPacket.data);
			} catch(GLib.Error objError){
				Logger.Log(objError.message, Logger.Level.Error);
			}
		}
		
	}
	
}
