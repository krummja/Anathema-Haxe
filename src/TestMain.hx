import common.graphgen.Graph.TestGraph1;
import common.graphgen.GraphQuery.TestGraph2;
import utest.Runner;
import utest.UTest;
import utest.ui.Report;

class TestMain {
	public static function main() {
		var runner = new Runner();
		runner.addCase(new TestGraph1());
		runner.addCase(new TestGraph2());
		Report.create(runner);
		runner.run();
	}
}
