package com.sofka.qa.demoblaze.runners;

import com.intuit.karate.junit5.Karate;

/**
 * Runner JUnit 5 para ejecutar los features de Karate de Demoblaze.
 * Ejecutar: ./mvnw test
 * Reporte  : target/karate-reports/karate-summary.html
 */
class DemoblazeRunner {

    @Karate.Test
    Karate testAuthFlow() {
        return Karate.run("classpath:demoblaze/auth.feature")
            .outputCucumberJson(true);
    }
}
