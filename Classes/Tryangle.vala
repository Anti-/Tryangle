namespace Tryangle {
	
	class Tryangle : TryangleBase {

		private GLib.KeyFile objParser;
		
		public Tryangle(string strServer){
			this.objServer = new GLib.SocketService();
			this.objParser = new GLib.KeyFile();
			uint16 intPort = 6112;
			try {
				this.objParser.load_from_file("Settings.conf", GLib.KeyFileFlags.NONE);
				intPort = (uint16)this.objParser.get_integer(strServer, "intPort");
				this.mapConfig["maxClients"] = this.objParser.get_value(strServer, "intMaxClients");
				this.mapConfig["maxPoolClients"] = this.objParser.get_value(strServer, "intMaxClientPerPool");
				this.mapConfig["maxPools"] = this.objParser.get_value(strServer, "intMaxPools");
				this.objServer.add_inet_port(intPort, null);
			} catch(GLib.Error objError){
				Logger.Log("Error: " + objError.message);
				this.shutDown();
			}
			this.objServer.start();
			Logger.Log("Tryangle 0.01 initialized on " + intPort.to_string());
		}
		
	}
	
}
