package conduit;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static helpers.CucumberReport.generateReport;
import static org.junit.jupiter.api.Assertions.*;

class ConduitTest {
    @Test
    void testParallel() {
        Results results = Runner.path("classpath:conduit")
                .outputCucumberJson(true).parallel(1);
        generateReport(results.getReportDir());
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
