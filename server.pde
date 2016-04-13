
void serverAction() {

  //testserver.write("0"); 
  
  Client c = server.available();
  if (c != null) {

    String input = c.readString();
    String httpline = input.substring(0, input.indexOf("\r\n")); // Only up to the newline
    
    c.write("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n");  
    c.write("<html><head><title>Processing server</title></head><body><h3>Jihuu");
    c.write("</h3></body></html>");
      
    
    for (int i=0; i<cubes.list.size(); i++) {
      int number = i+1;
      if (httpline.equals("GET /"+number+" HTTP/1.1")) {
        cubes.list.get(i).onPhone = true;
        break;
      }
      else if (httpline.equals("GET /"+number+"/off HTTP/1.1")) {
        cubes.list.get(i).onPhone = false;
        break;
      }
    }
    

    
    c.stop();
  }
}