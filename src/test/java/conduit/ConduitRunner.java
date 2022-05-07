package conduit;

import com.intuit.karate.junit5.Karate;

class ConduitRunner {
    @Karate.Test
    Karate testUsers() {
        return Karate.run("classpath:conduit").relativeTo(getClass());
    }

    @Karate.Test
    Karate testTags() {
        return Karate.run("classpath:conduit").tags("@debug").relativeTo(getClass());
    }
}