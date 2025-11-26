	package GameOfLife;

	import java.awt.Point;
	import java.util.ArrayList;

	public class RulesOfLife {
		public static void computeSurvivors(boolean[][] gameBoard, ArrayList<Point> survivingCells) {
        	// Iterate through the array, follow game of life rules
       	 for (int i=1; i<gameBoard.length-1; i++) {
            for (int j=1; j<gameBoard[0].length-1; j++) {
                int surrounding = 0;
                if (gameBoard[i-1][j-1]) { surrounding++; }
                if (gameBoard[i-1][j])   { surrounding++; }
                if (gameBoard[i-1][j+1]) { surrounding++; }
                if (gameBoard[i][j-1])   { surrounding++; }
                if (gameBoard[i][j+1])   { surrounding++; }
                if (gameBoard[i+1][j-1]) { surrounding++; }
                if (gameBoard[i+1][j])   { surrounding++; }
                if (gameBoard[i+1][j+1]) { surrounding++; }
                /* only code for surving cells, so no rule if result is dead cell */
                 /* rule B3 */
                if ((!gameBoard[i][j]) && (surrounding == 3)){
                	survivingCells.add(new Point(i-1,j-1));
                	} 
                  /* rule B6 */
                if ((!gameBoard[i][j]) && (surrounding == 6)){
                	survivingCells.add(new Point(i-1,j-1));
                	} 
                  /* rule S2 */
                if ((gameBoard[i][j]) && (surrounding == 2)){
                	survivingCells.add(new Point(i-1,j-1));
                	} 
            }
        }
	}

}
