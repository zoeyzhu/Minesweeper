import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 5;
private final static int NUM_COLS = 5;
private final static int NUM_MINES = 1;
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
    for (int r = 0; r< NUM_ROWS; r++){
     for (int c =0; c< NUM_COLS; c++){
       buttons[r][c] = new MSButton(r,c);
     }   
    }
    
    setMines();
}
public void setMines()
{
    //your code
    int randomRow, randomCol;
    for(int i = 0; i < NUM_MINES; i++){
      randomRow = (int)(Math.random()* NUM_ROWS);
      randomCol = (int)(Math.random()* NUM_COLS);
      //contains() only works with arraylist and strings
      if(!mines.contains(buttons[randomRow][randomCol])){
        mines.add(buttons[randomRow][randomCol]);
      }
    }
}

public void draw()
{
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    boolean nMines = false;
    boolean nonMines = false;
    
    int numMinesFlagged = 0;
    for(int i = 0; i < mines.size(); i++){
      if(mines.get(i).flagged == true)
        numMinesFlagged++;
    }
    if(numMinesFlagged == mines.size())
      nMines = true;
    return nMines;
}
public void displayLosingMessage()
{
  for(int r = 0; r < NUM_ROWS; r++){
  for(int c = 0; c < NUM_COLS; c++){
    Interactive.setActive(buttons[r][c], false);
   }
}
   background(0);
   fill(255);
   text("Loser", 200, 200);
   
}
public void displayWinningMessage()
{
    for(int r = 0; r < NUM_ROWS; r++){
  for(int c = 0; c < NUM_COLS; c++){
    Interactive.setActive(buttons[r][c], false);
   }
}
background(0);
   fill(255,288,225);
   text("CONGRATS!", 200, 200);
}
public boolean isValid(int r, int c)
{
    if ((r>=NUM_ROWS) || (c >= NUM_COLS) || (r<0) || (c <0)){
    return false;
  }
  return true;
}
public int countMines(int row, int col)
{
  //your code here
  int numMines = 0;
    for(int r = row-1; r<=row+1; r++){
      for(int c = col-1; c<=col+1; c++){
        if(mines.contains(buttons[row][col]) == true){
          numMines--;
        }
        if(isValid(r,c) == true && 
            mines.contains(buttons[r][c]) == true){
          numMines++;
        }
      }
    }
     return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
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
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if (mouseButton == RIGHT){
         flagged = !flagged; 
         if (flagged == false){
          clicked = false; 
         }          
        }
        else if(mines.contains(this)){
        displayLosingMessage(); 
      }
      else if(countMines(myRow,myCol) > 0){
        setLabel(countMines(myRow,myCol));
      }
        else{
        for(int r = myRow-1; r <= myRow+1; r++){
          for(int c = myCol-1; c <= myCol+1; c++){
            if(isValid(r,c) && buttons[r][c].clicked == false){
              buttons[r][c].mousePressed();
            }
          }
        }
      }
        
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
