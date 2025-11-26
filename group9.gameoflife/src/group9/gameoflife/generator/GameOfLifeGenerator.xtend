package group9.gameoflife.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import group9.gameoflife.gameOfLife.Model
import group9.gameoflife.gameOfLife.Comparator

class GameOfLifeGenerator extends AbstractGenerator {

    override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
        val model = resource.contents.get(0) as Model
        if (model.game !== null) {
            fsa.generateFile("GameOfLife/RulesOfLife.java", compile(model))
        }
    }

    def compile(Model model) '''
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
                
                /* Live rules */
                «FOR r : model.game.rules.birthRules SEPARATOR " else "»
                if ((!gameBoard[i][j]) && (surrounding «r.op.toJavaOp» «r.value»)) {
                	survivingCells.add(new Point(i-1, j-1));
                }
                «ENDFOR»
                
                /* Death rules */
				«FOR r : model.game.rules.deathRules SEPARATOR " else "»
				if ((gameBoard[i][j]) && (surrounding «r.op.toJavaOp» «r.value»)) {
					continue;
				}
                «ENDFOR»
                
                /* Survival rules */
                «FOR r : model.game.rules.survivalRules SEPARATOR " else "»
                if ((gameBoard[i][j]) && (surrounding «r.op.toJavaOp» «r.value»)) {
                	survivingCells.add(new Point(i-1, j-1));
                }
                «ENDFOR»
                
«««                if (gameBoard[i][j]) {
«««                    if (false «FOR rule : model.game.rules.survivalRules» || (surrounding «rule.op.toJavaOp» «rule.value»)«ENDFOR») {
«««                        survivingCells.add(new Point(i-1, j-1));
«««                    }
«««                } 
«««                // Check Birth Rules (Apply to currently Dead cells)
«««                else {
«««                    if (false «FOR rule : model.game.rules.birthRules» || (surrounding «rule.op.toJavaOp» «rule.value»)«ENDFOR») {
«««                        survivingCells.add(new Point(i-1, j-1));
«««                    }
«««                }
            }
        }
    }

    // Helper method to load the initial grid defined in the DSL
    public static ArrayList<Point> getInitialGrid() {
        ArrayList<Point> points = new ArrayList<Point>();
        «FOR cell : model.game.grid.cells»
        points.add(new Point(«cell.x», «cell.y»));
        «ENDFOR»
        return points;
    }
}
    '''

    def toJavaOp(Comparator op) {
        switch (op) {
            case Comparator.EQ: return "=="
            case Comparator.LT: return "<"
            case Comparator.GT: return ">"
        }
    }
}