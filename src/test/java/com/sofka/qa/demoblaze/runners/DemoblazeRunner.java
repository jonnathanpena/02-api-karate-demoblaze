package com.sofka.qa.demoblaze.runners;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner JUnit 5 para ejecutar los features de Karate de Demoblaze.
 * Ejecutar: ./mvnw test
 * Reporte  : target/karate-reports/karate-summary.html
 */
class DemoblazeRunner {

    @Test
    void testAuthFlow() {
        Karate.run("classpath:demoblaze/auth.feature").relativeTo(getClass());
    }
}
