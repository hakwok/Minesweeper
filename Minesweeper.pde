import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public boolean winner, loser = false;
private boolean isLose = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
      buttons[r][c] = new MSButton(r,c);
      }
    }
    for(int i = 0; i<50; i++){
      setMines();
    }
}
public void setMines()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row][col])){
      mines.add(buttons[row][col]);
  }
}

public void draw ()
{  
  background( 0 );
  if (isWon()) {
    displayWinningMessage();
    noLoop();
  }
  if(isLose) {
    displayLosingMessage();
    noLoop();
  }
}
public boolean isWon()
{
    for(int i = 0; i<mines.size(); i++)
    {
        if(!mines.get(i).isFlagged())
        {
            return false;
        }
    }
    return true;
}
public void displayLosingMessage()
{
    loser = true;
    for(int i = 0; i < buttons.length; i++)
    {
        if(mines.get(i).isFlagged() == false)
            mines.get(i).clicked = true;
    }
  fill(255);
  buttons[10][6].setLabel("Y");
  buttons[10][7].setLabel("O");
  buttons[10][8].setLabel("U");

  buttons[10][10].setLabel("L");
  buttons[10][11].setLabel("O");
  buttons[10][12].setLabel("S");
  buttons[10][13].setLabel("T");
  for(int i = 6; i < 14; i++) {
    buttons[10][i].setColor(255);
  }
}
public void displayWinningMessage()
{
  winner = true;
  buttons[10][6].setLabel("Y");
  buttons[10][7].setLabel("O");
  buttons[10][8].setLabel("U");

  buttons[10][10].setLabel("W");
  buttons[10][11].setLabel("I");
  buttons[10][12].setLabel("N");
  for(int i = 6; i < 14; i++) {
    buttons[10][i].setColor(255);
  }
}
public boolean isValid(int r, int c)
{
    return r >=0 && r<NUM_ROWS&& c>=0 && c<NUM_COLS;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int r = row-1; r<=row+1; r++)
      for (int c = col-1; c<=col+1; c++)
        if (isValid(r, c) && mines.contains(buttons[r][c]))
          numMines++;
        if (mines.contains(buttons[row][col]))
          numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    private color labelColor;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
        labelColor = 0;
    }
    public void setColor(color c) {
      labelColor = c;
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT && flagged == true){
          flagged = false;
          clicked = false;
        }
        if(mouseButton == RIGHT && flagged == false){
          flagged = true;
          clicked = false;
        }
        else if(mines.contains(this) == true){
          isLose = true;
          displayLosingMessage();
        }
        else if (countMines(myRow, myCol) > 0){
          setLabel(""+countMines(myRow, myCol));
        }
        else{
          if (isValid(myRow+1, myCol+1) && buttons[myRow+1][myCol+1].clicked == false) {
              buttons[myRow+1][myCol+1].mousePressed();
          }
          if (isValid(myRow+1, myCol-1) && buttons[myRow+1][myCol-1].clicked == false) {
              buttons[myRow+1][myCol-1].mousePressed();
          }
          if (isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked == false) {
              buttons[myRow+1][myCol].mousePressed();
          }
          if (isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked== false) {
              buttons[myRow-1][myCol].mousePressed();
          }
          if (isValid(myRow-1, myCol-1) && buttons[myRow-1][myCol-1].clicked == false) {
              buttons[myRow-1][myCol-1].mousePressed();
          }
          if (isValid(myRow-1, myCol+1) && buttons[myRow-1][myCol+1].clicked == false) {
              buttons[myRow-1][myCol+1].mousePressed();
          }
          if (isValid(myRow, myCol-1) && buttons[myRow][myCol-1].clicked == false) {
              buttons[myRow][myCol-1].mousePressed();
          }
          if (isValid(myRow, myCol+1) && buttons[myRow][myCol+1].clicked == false) {
              buttons[myRow][myCol+1].mousePressed();
          }
        }

    }
    public void draw () 
    {    
        if(flagged){
            fill(255);
        }
        else if(clicked && mines.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            //fill(100, 200, 100);
            fill((int)(Math.random()*100), (int)(Math.random()*100), (int)(Math.random()*100));

        rect(x, y, width, height);
        fill(labelColor);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = "" + newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
