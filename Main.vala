namespace Tryangle {
	
	void main(){
		GLib.MainLoop objLoop = new GLib.MainLoop();
		Tryangle objTryangle = new Tryangle("Login");
		objTryangle.run();
		objLoop.run();
	}
	
}
