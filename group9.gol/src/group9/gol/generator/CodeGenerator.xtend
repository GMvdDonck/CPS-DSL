package group9.gol.generator

import group9.gol.goLDSL.Game
import group9.gol.goLDSL.DeathRule
import group9.gol.goLDSL.LiveRule
import group9.gol.goLDSL.SurviveRule

class CodeGenerator {
	def static toJava(Game root)'''
			package GameOfLife;
			
			import java.awt.Point;
			import java.util.ArrayList;
			
			public class RulesOfLife {
				public static void computeSurvivors(boolean[][] gameBoard, ArrayList<Point> survivingCells) {
					// Iterate through the array, follow game of life rules
					for (int i = 1; i < gameBoard.length - 1; i++) {
						for (int j = 1; j < gameBoard[0].length - 1; j++) {
				            int surrounding = 0;
				            if (gameBoard[i-1][j-1]) { surrounding++; }
				            if (gameBoard[i-1][j])   { surrounding++; }
				            if (gameBoard[i-1][j+1]) { surrounding++; }
				            if (gameBoard[i][j-1])   { surrounding++; }
				            if (gameBoard[i][j+1])   { surrounding++; }
				            if (gameBoard[i+1][j-1]) { surrounding++; }
				            if (gameBoard[i+1][j])   { surrounding++; }
				            if (gameBoard[i+1][j+1]) { surrounding++; }

				            /* Live rules */
							«ruleStatement(root.r.LRule)»
							/* Death rules */
							«ruleStatement(root.r.DRule)»
							/* Survival rules */
							«ruleStatement(root.r.SRule)»
						}
					}
				}
				
				// TODO: fill this arraylist with coordinates of cells
				public static void setInitialBoard(ArrayList<Point> initialCells) {
					
				}
			}'''
			
//			TODO: This has got to work without naming each rule in the xtext directly
	def static dispatch ruleStatement(LiveRule rules)'''
			«FOR r : rules.rules SEPARATOR "\n"»
			if ((!gameboard[i][j]) && (surrounding «rule.relation» «rule.neighbours»)) {
				survivingCells.add(new Point(i - 1, j - 1));
			}
			«ENDFOR»'''
	def static dispatch ruleStatement(DeathRule rules)'''
			«FOR r : rules.rules SEPARATOR "\n"»
			if ((gameboard[i][j]) && (surrounding «rule.relation» «rule.neighbours»)) {
				continue;
			}
			«ENDFOR»'''
	def static dispatch ruleStatement(SurviveRule rules)'''
			«FOR r : rules.rules SEPARATOR "\n"»
			if ((gameboard[i][j]) && (surrounding «rule.relation» «rule.neighbours»)) {
				survivingCells.add(new Point(i - 1, j - 1));
			}
			«ENDFOR»'''

}
