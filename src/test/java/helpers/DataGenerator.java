package helpers;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;

public class DataGenerator {
    private static final Faker faker = new Faker();
    
    public static String getRandomEmail(){
        String email = faker.name().firstName().toLowerCase() + faker.random().nextInt(0, 100) + "@test.com";
        return email;
    }

    public static String getRandomUsername(){
        String username = faker.name().username();
        return username;
    }

    public String getEmail() {
        return faker.name().lastName() + "@email.com";
    }

    public static JSONObject getRandomArticleValues(){
        String title = faker.company().buzzword();
        String description = faker.book().title();
        String body = faker.buffy().characters();
        JSONObject json = new JSONObject();
        json.put("title", title);
        json.put("description", description);
        json.put("body", body);
        return json;
    }

}