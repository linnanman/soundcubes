public class LedControl {
  private Serial serialPort;
  private int firstLedStatus = -1;
  private int secondLedStatus = -1;
  private int thirdLedStatus = -1;
  
  public LedControl(Serial serialPort) {
    this.serialPort = serialPort;
  }
  
  public void ChangeLed(int first, int second, int third) {
    if (firstLedStatus != first || secondLedStatus != second || thirdLedStatus != third) {
      firstLedStatus = first;
      secondLedStatus = second;
      thirdLedStatus = third;
      if (useSerial)
        serialPort.write(first+","+second+","+third+"\r\n");
    }
  }
  
  public void SetFirstLed(int status) {
    ChangeLed(status, secondLedStatus, thirdLedStatus); 
  }
  
  public void SetSecondLed(int status) {
    ChangeLed(firstLedStatus, status, thirdLedStatus);
  }
  
  public void SetThirdLed(int status) {
    ChangeLed(firstLedStatus, secondLedStatus, status);
  }
}