# D.A.T.I. API Test Results

**Run at:** 2026-04-05T18:14:02.333Z

**Server:** http://localhost:3100

**Summary:** 60 PASS / 0 FAIL (total 60)


---


## [PASS] GET /api/health
- **Description:** Health check returns ok
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
{
  "status": "ok",
  "db": "connected"
}
```

## [PASS] POST /api/auth/setup
- **Description:** Setup password for existing user admin
- **Expected status:** 200
- **Received status:** 200
- **Request body:**
```json
{
  "username": "admin",
  "password": "testpass123"
}
```
- **Response body:**
```json
{
  "message": "Password set for admin"
}
```

## [PASS] POST /api/auth/setup
- **Description:** Setup missing password -> 400
- **Expected status:** 400
- **Received status:** 400
- **Request body:**
```json
{
  "username": "admin"
}
```
- **Response body:**
```json
{
  "error": "Username and password required"
}
```

## [PASS] POST /api/auth/setup
- **Description:** Setup empty body -> 400
- **Expected status:** 400
- **Received status:** 400
- **Request body:**
```json
{}
```
- **Response body:**
```json
{
  "error": "Username and password required"
}
```

## [PASS] POST /api/auth/setup
- **Description:** Setup nonexistent user -> 404
- **Expected status:** 404
- **Received status:** 404
- **Request body:**
```json
{
  "username": "nosuchuser_xyz",
  "password": "abc12345"
}
```
- **Response body:**
```json
{
  "error": "User not found"
}
```

## [PASS] POST /api/auth/setup
- **Description:** Setup SQL injection in username -> 404 (param binding)
- **Expected status:** 404
- **Received status:** 404
- **Request body:**
```json
{
  "username": "admin' OR '1'='1",
  "password": "hack"
}
```
- **Response body:**
```json
{
  "error": "User not found"
}
```

## [PASS] POST /api/auth/login
- **Description:** Valid login returns JWT
- **Expected status:** 200
- **Received status:** 200
- **Request body:**
```json
{
  "username": "admin",
  "password": "testpass123"
}
```
- **Response body:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc3NTQxMjg0MSwiZXhwIjoxNzc1NDQxNjQxfQ.D2AVVIKNw72rAwS3PXlxZfxU6j2eTj2xgo3YSK_JTEg",
  "user": {
    "id": 1,
    "username": "admin",
    "display_name": "Cellar Door Admin",
    "role": "admin"
  }
}
```

## [PASS] POST /api/auth/login
- **Description:** Login with bad password -> 401
- **Expected status:** 401
- **Received status:** 401
- **Request body:**
```json
{
  "username": "admin",
  "password": "wrongpass"
}
```
- **Response body:**
```json
{
  "error": "Invalid credentials"
}
```

## [PASS] POST /api/auth/login
- **Description:** Login unknown user -> 401
- **Expected status:** 401
- **Received status:** 401
- **Request body:**
```json
{
  "username": "ghost",
  "password": "whatever"
}
```
- **Response body:**
```json
{
  "error": "Invalid credentials"
}
```

## [PASS] POST /api/auth/login
- **Description:** Login missing password -> 400
- **Expected status:** 400
- **Received status:** 400
- **Request body:**
```json
{
  "username": "admin"
}
```
- **Response body:**
```json
{
  "error": "Username and password required"
}
```

## [PASS] POST /api/auth/login
- **Description:** Login empty body -> 400
- **Expected status:** 400
- **Received status:** 400
- **Request body:**
```json
{}
```
- **Response body:**
```json
{
  "error": "Username and password required"
}
```

## [PASS] POST /api/auth/login
- **Description:** Login SQL injection -> 401 (param binding)
- **Expected status:** 401
- **Received status:** 401
- **Request body:**
```json
{
  "username": "admin' OR 1=1 --",
  "password": "x"
}
```
- **Response body:**
```json
{
  "error": "Invalid credentials"
}
```

## [PASS] GET /api/themes
- **Description:** List themes (public)
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
[
  {
    "id": 3,
    "name": "2000s Nostalgia",
    "description": "Pop culture, tech, TV shows, and trends from the Y2K decade.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 15
  },
  {
    "id": 1,
    "name": "American History",
    "description": "From the Revolution to modern day — test your knowledge of U.S. history.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 15
  },
  {
    "id": 6,
    "name": "Food & Drink",
    "description": "Culinary trivia from around the world — perfect for a pub night.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 10
  },
  {
    "id": 2,
    "name": "Music Through the Decades",
    "description": "Hits, artists, and moments that defined each era of music.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 15
  },
  {
    "id": 4,
    "name": "Science & Nature",
    "description": "The natural world, space, chemistry, and everything in between.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 10
  },
  {
    "id": 5,
    "name": "Sports Legends",
    "description": "Iconic athletes, championship moments, and record-breakers.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 10
  }
]
```

## [PASS] POST /api/themes
- **Description:** Create theme without auth -> 401
- **Expected status:** 401
- **Received status:** 401
- **Request body:**
```json
{
  "name": "NoAuth"
}
```
- **Response body:**
```json
{
  "error": "No token provided"
}
```

## [PASS] POST /api/themes
- **Description:** Create theme with bad JWT -> 401
- **Expected status:** 401
- **Received status:** 401
- **Auth header:** `Bearer totally.fake.token`
- **Request body:**
```json
{
  "name": "BadAuth"
}
```
- **Response body:**
```json
{
  "error": "Invalid token"
}
```

## [PASS] POST /api/themes
- **Description:** Create theme missing name -> 400
- **Expected status:** 400
- **Received status:** 400
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "description": "No name"
}
```
- **Response body:**
```json
{
  "error": "Theme name is required"
}
```

## [PASS] POST /api/themes
- **Description:** Create theme valid -> 201
- **Expected status:** 201
- **Received status:** 201
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "name": "TestTheme_1775412841955",
  "description": "A test theme"
}
```
- **Response body:**
```json
{
  "id": 7,
  "name": "TestTheme_1775412841955",
  "description": "A test theme",
  "is_active": 1,
  "created_at": "2026-04-05T18:14:01.000Z",
  "updated_at": "2026-04-05T18:14:01.000Z"
}
```

## [PASS] POST /api/themes
- **Description:** Create duplicate theme -> 409
- **Expected status:** 409
- **Received status:** 409
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "name": "TestTheme_1775412841955"
}
```
- **Response body:**
```json
{
  "error": "Theme name already exists"
}
```

## [PASS] POST /api/themes
- **Description:** SQL injection theme name -> 201 (safely escaped)
- **Expected status:** 201
- **Received status:** 201
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "name": "Robert'); DROP TABLE themes;--"
}
```
- **Response body:**
```json
{
  "id": 9,
  "name": "Robert'); DROP TABLE themes;--",
  "description": null,
  "is_active": 1,
  "created_at": "2026-04-05T18:14:01.000Z",
  "updated_at": "2026-04-05T18:14:01.000Z"
}
```

## [PASS] GET /api/themes/7
- **Description:** Get single theme by id
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
{
  "id": 7,
  "name": "TestTheme_1775412841955",
  "description": "A test theme",
  "is_active": 1,
  "created_at": "2026-04-05T18:14:01.000Z",
  "updated_at": "2026-04-05T18:14:01.000Z",
  "questions": []
}
```

## [PASS] GET /api/themes/999999
- **Description:** Get nonexistent theme -> 404
- **Expected status:** 404
- **Received status:** 404
- **Response body:**
```json
{
  "error": "Theme not found"
}
```

## [PASS] GET /api/themes/not-a-number
- **Description:** Get theme with invalid id string
- **Expected status:** 404 or 500
- **Received status:** 404
- **Response body:**
```json
{
  "error": "Theme not found"
}
```

## [PASS] PUT /api/themes/7
- **Description:** Update theme without auth -> 401
- **Expected status:** 401
- **Received status:** 401
- **Request body:**
```json
{
  "name": "x"
}
```
- **Response body:**
```json
{
  "error": "No token provided"
}
```

## [PASS] PUT /api/themes/7
- **Description:** Update theme description
- **Expected status:** 200
- **Received status:** 200
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "description": "Updated description"
}
```
- **Response body:**
```json
{
  "id": 7,
  "name": "TestTheme_1775412841955",
  "description": "Updated description",
  "is_active": 1,
  "created_at": "2026-04-05T18:14:01.000Z",
  "updated_at": "2026-04-05T18:14:02.000Z"
}
```

## [PASS] PUT /api/themes/7
- **Description:** Update theme no fields -> 400
- **Expected status:** 400
- **Received status:** 400
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{}
```
- **Response body:**
```json
{
  "error": "No fields to update"
}
```

## [PASS] DELETE /api/themes/7
- **Description:** Delete theme without auth -> 401
- **Expected status:** 401
- **Received status:** 401
- **Response body:**
```json
{
  "error": "No token provided"
}
```

## [PASS] POST /api/themes
- **Description:** Create theme for question tests
- **Expected status:** 201
- **Received status:** 201
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "name": "QTheme_1775412842059"
}
```
- **Response body:**
```json
{
  "id": 10,
  "name": "QTheme_1775412842059",
  "description": null,
  "is_active": 1,
  "created_at": "2026-04-05T18:14:02.000Z",
  "updated_at": "2026-04-05T18:14:02.000Z"
}
```

## [PASS] GET /api/questions
- **Description:** List questions (public)
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
[
  {
    "id": 1,
    "theme_id": 1,
    "question_text": "In what year was the Declaration of Independence signed?",
    "option_a": "1774",
    "option_b": "1776",
    "option_c": "1778",
    "option_d": "1781",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 2,
    "theme_id": 1,
    "question_text": "Who was the first President of the United States?",
    "option_a": "John Adams",
    "option_b": "Thomas Jefferson",
    "option_c": "George Washington",
    "option_d": "Benjamin Franklin",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 6,
    "theme_id": 1,
    "question_text": "Who purchased the Louisiana Territory from France?",
    "option_a": "George Washington",
    "option_b": "John Adams",
    "option_c": "Thomas Jefferson",
    "option_d": "James Madison",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 8,
    "theme_id": 1,
    "question_text": "What document begins with \"We the People\"?",
    "option_a": "Declaration of Independence",
    "option_b": "Bill of Rights",
    "option_c": "U.S. Constitution",
    "option_d": "Articles of Confederation",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 9,
    "theme_id": 1,
    "question_text": "Which President issued the Emancipation Proclamation?",
    "option_a": "Ulysses S. Grant",
    "option_b": "Abraham Lincoln",
    "option_c": "Andrew Johnson",
    "option_d": "James Buchanan",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 11,
    "theme_id": 1,
    "question_text": "Who was President during the Cuban Missile Crisis?",
    "option_a": "Dwight Eisenhower",
    "option_b": "John F. Kennedy",
    "option_c": "Lyndon Johnson",
    "option_d": "Richard Nixon",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 3,
    "theme_id": 1,
    "question_text": "Which amendment abolished slavery in the United States?",
    "option_a": "12th",
    "option_b": "13th",
    "option_c": "14th",
    "option_d": "15th",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 4,
    "theme_id": 1,
    "question_text": "What was the last state to join the Union?",
    "option_a": "Alaska",
    "option_b": "Hawaii",
    "option_c": "Arizona",
    "option_d": "New Mexico",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 5,
    "theme_id": 1,
    "question_text": "Which battle is considered the turning point of the Civil War?",
    "option_a": "Battle of Antietam",
    "option_b": "Battle of Gettysburg",
    "option_c": "Battle of Bull Run",
    "option_d": "Battle of Shiloh",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 7,
    "theme_id": 1,
    "question_text": "In what year did the United States enter World War I?",
    "option_a": "1914",
    "option_b": "1915",
    "option_c": "1916",
    "option_d": "1917",
    "correct_answer": "D",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 10,
    "theme_id": 1,
    "question_text": "The Trail of Tears was the forced relocation of which group?",
    "option_a": "African Americans",
    "option_b": "Japanese Americans",
    "option_c": "Native Americans",
    "option_d": "Mexican Americans",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 12,
    "theme_id": 1,
    "question_text": "What year did women gain the right to vote in the U.S.?",
    "option_a": "1918",
    "option_b": "1919",
    "option_c": "1920",
    "option_d": "1921",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 14,
    "theme_id": 1,
    "question_text": "What was the code name for the Allied invasion of Normandy?",
    "option_a": "Operation Torch",
    "option_b": "Operation Overlord",
    "option_c": "Operation Market Garden",
    "option_d": "Operation Barbarossa",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 15,
    "theme_id": 1,
    "question_text": "The Boston Tea Party was a protest against what?",
    "option_a": "Stamp Act",
    "option_b": "Sugar Act",
    "option_c": "Tea Act",
    "option_d": "Townshend Acts",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 13,
    "theme_id": 1,
    "question_text": "Which President served the shortest term in office?",
    "option_a": "Zachary Taylor",
    "option_b": "James Garfield",
    "option_c": "William Henry Harrison",
    "option_d": "Warren Harding",
    "correct_answer": "C",
    "difficulty": "hard",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 16,
    "theme_id": 2,
    "question_text": "Which band released the album \"Abbey Road\"?",
    "option_a": "The Rolling Stones",
    "option_b": "The Beatles",
    "option_c": "The Who",
    "option_d": "Led Zeppelin",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 17,
    "theme_id": 2,
    "question_text": "What instrument does a drummer play?",
    "option_a": "Guitar",
    "option_b": "Bass",
    "option_c": "Drums",
    "option_d": "Keyboard",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 18,
    "theme_id": 2,
    "question_text": "Who is known as the \"King of Pop\"?",
    "option_a": "Prince",
    "option_b": "Michael Jackson",
    "option_c": "Elvis Presley",
    "option_d": "Stevie Wonder",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 19,
    "theme_id": 2,
    "question_text": "Which artist released \"Purple Rain\" in 1984?",
    "option_a": "David Bowie",
    "option_b": "Michael Jackson",
    "option_c": "Prince",
    "option_d": "Bruce Springsteen",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 21,
    "theme_id": 2,
    "question_text": "Which Woodstock festival took place in 1969?",
    "option_a": "Woodstock 94",
    "option_b": "The original Woodstock",
    "option_c": "Woodstock 99",
    "option_d": "Woodstock 2009",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 22,
    "theme_id": 2,
    "question_text": "Who sang \"Respect\" and is the Queen of Soul?",
    "option_a": "Diana Ross",
    "option_b": "Tina Turner",
    "option_c": "Aretha Franklin",
    "option_d": "Whitney Houston",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 28,
    "theme_id": 2,
    "question_text": "Which female artist had a hit with \"Like a Virgin\" in 1984?",
    "option_a": "Cyndi Lauper",
    "option_b": "Madonna",
    "option_c": "Whitney Houston",
    "option_d": "Janet Jackson",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 30,
    "theme_id": 2,
    "question_text": "Which band is known for the song \"Stairway to Heaven\"?",
    "option_a": "Pink Floyd",
    "option_b": "Led Zeppelin",
    "option_c": "Deep Purple",
    "option_d": "Black Sabbath",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 20,
    "theme_id": 2,
    "question_text": "What genre did The Ramones help pioneer?",
    "option_a": "Disco",
    "option_b": "Punk rock",
    "option_c": "New wave",
    "option_d": "Grunge",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 23,
    "theme_id": 2,
    "question_text": "What was Nirvana's breakthrough album?",
    "option_a": "Bleach",
    "option_b": "Nevermind",
    "option_c": "In Utero",
    "option_d": "Unplugged in New York",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 24,
    "theme_id": 2,
    "question_text": "Which rapper released \"The Marshall Mathers LP\"?",
    "option_a": "Jay-Z",
    "option_b": "50 Cent",
    "option_c": "Eminem",
    "option_d": "Kanye West",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 25,
    "theme_id": 2,
    "question_text": "What year did MTV first go on the air?",
    "option_a": "1979",
    "option_b": "1980",
    "option_c": "1981",
    "option_d": "1982",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 27,
    "theme_id": 2,
    "question_text": "Who wrote \"Bohemian Rhapsody\"?",
    "option_a": "Elton John",
    "option_b": "Freddie Mercury",
    "option_c": "David Bowie",
    "option_d": "Mick Jagger",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 26,
    "theme_id": 2,
    "question_text": "Which band performed the halftime show at Super Bowl XLII in 2008?",
    "option_a": "The Rolling Stones",
    "option_b": "U2",
    "option_c": "Tom Petty & the Heartbreakers",
    "option_d": "Bruce Springsteen",
    "correct_answer": "C",
    "difficulty": "hard",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 29,
    "theme_id": 2,
    "question_text": "What was Elvis Presley's first number-one hit?",
    "option_a": "Jailhouse Rock",
    "option_b": "Hound Dog",
    "option_c": "Heartbreak Hotel",
    "option_d": "Love Me Tender",
    "correct_answer": "C",
    "difficulty": "hard",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 31,
    "theme_id": 3,
    "question_text": "What social media platform launched in 2004?",
    "option_a": "Twitter",
    "option_b": "MySpace",
    "option_c": "Facebook",
    "option_d": "Instagram",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 32,
    "theme_id": 3,
    "question_text": "Which phone was released by Apple in 2007?",
    "option_a": "iPod Touch",
    "option_b": "iPhone",
    "option_c": "iPad",
    "option_d": "Blackberry",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 34,
    "theme_id": 3,
    "question_text": "Which TV show featured the characters Jack, Kate, and Sawyer on a mysterious island?",
    "option_a": "Survivor",
    "option_b": "Lost",
    "option_c": "The OC",
    "option_d": "Heroes",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 36,
    "theme_id": 3,
    "question_text": "Which movie franchise began with \"The Fellowship of the Ring\" in 2001?",
    "option_a": "Harry Potter",
    "option_b": "The Matrix",
    "option_c": "Lord of the Rings",
    "option_d": "Star Wars Prequels",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 37,
    "theme_id": 3,
    "question_text": "What portable music player dominated the 2000s?",
    "option_a": "Zune",
    "option_b": "Walkman",
    "option_c": "iPod",
    "option_d": "MiniDisc",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 38,
    "theme_id": 3,
    "question_text": "Which reality TV show first aired in 2002 and featured Simon Cowell?",
    "option_a": "The Voice",
    "option_b": "American Idol",
    "option_c": "X Factor",
    "option_d": "America's Got Talent",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 40,
    "theme_id": 3,
    "question_text": "Which video platform launched in 2005?",
    "option_a": "Vimeo",
    "option_b": "YouTube",
    "option_c": "Dailymotion",
    "option_d": "Twitch",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 42,
    "theme_id": 3,
    "question_text": "Which animated movie featured a clownfish searching for his son?",
    "option_a": "Shark Tale",
    "option_b": "Finding Nemo",
    "option_c": "The Little Mermaid 2",
    "option_d": "SpongeBob Movie",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 43,
    "theme_id": 3,
    "question_text": "What was Tom from MySpace famous for?",
    "option_a": "Creating viral videos",
    "option_b": "Being everyone's first friend",
    "option_c": "Inventing hashtags",
    "option_d": "Starting Facebook",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 44,
    "theme_id": 3,
    "question_text": "Which gaming console did Nintendo release in 2006?",
    "option_a": "GameCube",
    "option_b": "Nintendo DS",
    "option_c": "Wii",
    "option_d": "Switch",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 45,
    "theme_id": 3,
    "question_text": "What low-rise fashion trend was everywhere in the early 2000s?",
    "option_a": "Bell bottoms",
    "option_b": "Low-rise jeans",
    "option_c": "Cargo pants",
    "option_d": "Skinny jeans",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 33,
    "theme_id": 3,
    "question_text": "What was the name of the virtual world game popular in the early 2000s?",
    "option_a": "Minecraft",
    "option_b": "Second Life",
    "option_c": "Club Penguin",
    "option_d": "Roblox",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 35,
    "theme_id": 3,
    "question_text": "What dance move became viral from the song \"Crank That\"?",
    "option_a": "The Dougie",
    "option_b": "Superman",
    "option_c": "The Stanky Leg",
    "option_d": "The Running Man",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 39,
    "theme_id": 3,
    "question_text": "What was the name of the popular IM client with a running man logo?",
    "option_a": "MSN Messenger",
    "option_b": "Yahoo Messenger",
    "option_c": "AIM",
    "option_d": "ICQ",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 41,
    "theme_id": 3,
    "question_text": "What flip phone was the best-selling phone of 2004?",
    "option_a": "Nokia 3310",
    "option_b": "Motorola Razr",
    "option_c": "Samsung SGH",
    "option_d": "LG Chocolate",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 46,
    "theme_id": 4,
    "question_text": "What planet is known as the Red Planet?",
    "option_a": "Venus",
    "option_b": "Mars",
    "option_c": "Jupiter",
    "option_d": "Saturn",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 47,
    "theme_id": 4,
    "question_text": "What is the chemical symbol for water?",
    "option_a": "H2O",
    "option_b": "CO2",
    "option_c": "O2",
    "option_d": "NaCl",
    "correct_answer": "A",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 50,
    "theme_id": 4,
    "question_text": "What gas do plants absorb from the atmosphere?",
    "option_a": "Oxygen",
    "option_b": "Nitrogen",
    "option_c": "Carbon dioxide",
    "option_d": "Hydrogen",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 52,
    "theme_id": 4,
    "question_text": "Which element has the atomic number 1?",
    "option_a": "Helium",
    "option_b": "Hydrogen",
    "option_c": "Oxygen",
    "option_d": "Carbon",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 53,
    "theme_id": 4,
    "question_text": "What is the hardest natural substance on Earth?",
    "option_a": "Granite",
    "option_b": "Quartz",
    "option_c": "Diamond",
    "option_d": "Topaz",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 48,
    "theme_id": 4,
    "question_text": "How many bones are in the adult human body?",
    "option_a": "186",
    "option_b": "196",
    "option_c": "206",
    "option_d": "216",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 49,
    "theme_id": 4,
    "question_text": "What is the largest organ in the human body?",
    "option_a": "Liver",
    "option_b": "Brain",
    "option_c": "Lungs",
    "option_d": "Skin",
    "correct_answer": "D",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 54,
    "theme_id": 4,
    "question_text": "How long does it take light from the Sun to reach Earth?",
    "option_a": "4 minutes",
    "option_b": "8 minutes",
    "option_c": "12 minutes",
    "option_d": "16 minutes",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 51,
    "theme_id": 4,
    "question_text": "What is the speed of light in miles per second (approx)?",
    "option_a": "86,000",
    "option_b": "186,000",
    "option_c": "286,000",
    "option_d": "386,000",
    "correct_answer": "B",
    "difficulty": "hard",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 55,
    "theme_id": 4,
    "question_text": "What animal has the longest lifespan?",
    "option_a": "Elephant",
    "option_b": "Blue whale",
    "option_c": "Galápagos tortoise",
    "option_d": "Greenland shark",
    "correct_answer": "D",
    "difficulty": "hard",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 56,
    "theme_id": 5,
    "question_text": "How many rings did Michael Jordan win with the Chicago Bulls?",
    "option_a": "4",
    "option_b": "5",
    "option_c": "6",
    "option_d": "7",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 58,
    "theme_id": 5,
    "question_text": "In what sport would you perform a \"slam dunk\"?",
    "option_a": "Football",
    "option_b": "Basketball",
    "option_c": "Tennis",
    "option_d": "Volleyball",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 61,
    "theme_id": 5,
    "question_text": "What is the length of a marathon in miles (approx)?",
    "option_a": "20.2",
    "option_b": "24.2",
    "option_c": "26.2",
    "option_d": "28.2",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 62,
    "theme_id": 5,
    "question_text": "Which boxer was known as \"The Greatest\"?",
    "option_a": "Mike Tyson",
    "option_b": "Sugar Ray Leonard",
    "option_c": "Muhammad Ali",
    "option_d": "Floyd Mayweather",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 57,
    "theme_id": 5,
    "question_text": "Who holds the record for most home runs in a single MLB season?",
    "option_a": "Mark McGwire",
    "option_b": "Barry Bonds",
    "option_c": "Sammy Sosa",
    "option_d": "Babe Ruth",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 59,
    "theme_id": 5,
    "question_text": "Which country has won the most FIFA World Cup titles?",
    "option_a": "Germany",
    "option_b": "Argentina",
    "option_c": "Brazil",
    "option_d": "Italy",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 60,
    "theme_id": 5,
    "question_text": "Who is the all-time leading scorer in NBA history?",
    "option_a": "Kareem Abdul-Jabbar",
    "option_b": "Karl Malone",
    "option_c": "LeBron James",
    "option_d": "Michael Jordan",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 64,
    "theme_id": 5,
    "question_text": "Who won 23 Grand Slam singles titles in tennis?",
    "option_a": "Roger Federer",
    "option_b": "Rafael Nadal",
    "option_c": "Novak Djokovic",
    "option_d": "Serena Williams",
    "correct_answer": "D",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 65,
    "theme_id": 5,
    "question_text": "In what year were the first modern Olympic Games held?",
    "option_a": "1886",
    "option_b": "1892",
    "option_c": "1896",
    "option_d": "1900",
    "correct_answer": "C",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 63,
    "theme_id": 5,
    "question_text": "What NFL team has won the most Super Bowls?",
    "option_a": "Dallas Cowboys",
    "option_b": "New England Patriots",
    "option_c": "Pittsburgh Steelers",
    "option_d": "San Francisco 49ers",
    "correct_answer": "B",
    "difficulty": "hard",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 67,
    "theme_id": 6,
    "question_text": "What is the main ingredient in guacamole?",
    "option_a": "Tomato",
    "option_b": "Avocado",
    "option_c": "Lime",
    "option_d": "Jalapeño",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 68,
    "theme_id": 6,
    "question_text": "What type of pasta is shaped like small tubes?",
    "option_a": "Spaghetti",
    "option_b": "Fettuccine",
    "option_c": "Penne",
    "option_d": "Linguine",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 69,
    "theme_id": 6,
    "question_text": "Which spirit is the main ingredient in a Margarita?",
    "option_a": "Rum",
    "option_b": "Vodka",
    "option_c": "Tequila",
    "option_d": "Gin",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 71,
    "theme_id": 6,
    "question_text": "Sushi originated in which country?",
    "option_a": "China",
    "option_b": "Japan",
    "option_c": "Korea",
    "option_d": "Thailand",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 72,
    "theme_id": 6,
    "question_text": "What gives bread its rise?",
    "option_a": "Baking soda",
    "option_b": "Yeast",
    "option_c": "Salt",
    "option_d": "Sugar",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 73,
    "theme_id": 6,
    "question_text": "Which cheese is traditionally used on a Margherita pizza?",
    "option_a": "Cheddar",
    "option_b": "Parmesan",
    "option_c": "Mozzarella",
    "option_d": "Gouda",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 74,
    "theme_id": 6,
    "question_text": "What fruit is used to make wine?",
    "option_a": "Apple",
    "option_b": "Grape",
    "option_c": "Cherry",
    "option_d": "Pear",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 70,
    "theme_id": 6,
    "question_text": "What is the most consumed beverage in the world after water?",
    "option_a": "Coffee",
    "option_b": "Tea",
    "option_c": "Beer",
    "option_d": "Milk",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 75,
    "theme_id": 6,
    "question_text": "A \"pub\" is short for what?",
    "option_a": "Public bar",
    "option_b": "Public house",
    "option_c": "Pub and grub",
    "option_d": "Public hub",
    "correct_answer": "B",
    "difficulty": "medium",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 66,
    "theme_id": 6,
    "question_text": "What country is the origin of the croissant?",
    "option_a": "France",
    "option_b": "Austria",
    "option_c": "Italy",
    "option_d": "Belgium",
    "correct_answer": "B",
    "difficulty": "hard",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  }
]
```

## [PASS] GET /api/questions?theme_id=10
- **Description:** List questions filtered by theme_id
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
[]
```

## [PASS] GET /api/questions?difficulty=easy
- **Description:** List questions filtered by difficulty
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
[
  {
    "id": 1,
    "theme_id": 1,
    "question_text": "In what year was the Declaration of Independence signed?",
    "option_a": "1774",
    "option_b": "1776",
    "option_c": "1778",
    "option_d": "1781",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 2,
    "theme_id": 1,
    "question_text": "Who was the first President of the United States?",
    "option_a": "John Adams",
    "option_b": "Thomas Jefferson",
    "option_c": "George Washington",
    "option_d": "Benjamin Franklin",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 6,
    "theme_id": 1,
    "question_text": "Who purchased the Louisiana Territory from France?",
    "option_a": "George Washington",
    "option_b": "John Adams",
    "option_c": "Thomas Jefferson",
    "option_d": "James Madison",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 8,
    "theme_id": 1,
    "question_text": "What document begins with \"We the People\"?",
    "option_a": "Declaration of Independence",
    "option_b": "Bill of Rights",
    "option_c": "U.S. Constitution",
    "option_d": "Articles of Confederation",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 9,
    "theme_id": 1,
    "question_text": "Which President issued the Emancipation Proclamation?",
    "option_a": "Ulysses S. Grant",
    "option_b": "Abraham Lincoln",
    "option_c": "Andrew Johnson",
    "option_d": "James Buchanan",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 11,
    "theme_id": 1,
    "question_text": "Who was President during the Cuban Missile Crisis?",
    "option_a": "Dwight Eisenhower",
    "option_b": "John F. Kennedy",
    "option_c": "Lyndon Johnson",
    "option_d": "Richard Nixon",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History"
  },
  {
    "id": 16,
    "theme_id": 2,
    "question_text": "Which band released the album \"Abbey Road\"?",
    "option_a": "The Rolling Stones",
    "option_b": "The Beatles",
    "option_c": "The Who",
    "option_d": "Led Zeppelin",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 17,
    "theme_id": 2,
    "question_text": "What instrument does a drummer play?",
    "option_a": "Guitar",
    "option_b": "Bass",
    "option_c": "Drums",
    "option_d": "Keyboard",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 18,
    "theme_id": 2,
    "question_text": "Who is known as the \"King of Pop\"?",
    "option_a": "Prince",
    "option_b": "Michael Jackson",
    "option_c": "Elvis Presley",
    "option_d": "Stevie Wonder",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 19,
    "theme_id": 2,
    "question_text": "Which artist released \"Purple Rain\" in 1984?",
    "option_a": "David Bowie",
    "option_b": "Michael Jackson",
    "option_c": "Prince",
    "option_d": "Bruce Springsteen",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 21,
    "theme_id": 2,
    "question_text": "Which Woodstock festival took place in 1969?",
    "option_a": "Woodstock 94",
    "option_b": "The original Woodstock",
    "option_c": "Woodstock 99",
    "option_d": "Woodstock 2009",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 22,
    "theme_id": 2,
    "question_text": "Who sang \"Respect\" and is the Queen of Soul?",
    "option_a": "Diana Ross",
    "option_b": "Tina Turner",
    "option_c": "Aretha Franklin",
    "option_d": "Whitney Houston",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 28,
    "theme_id": 2,
    "question_text": "Which female artist had a hit with \"Like a Virgin\" in 1984?",
    "option_a": "Cyndi Lauper",
    "option_b": "Madonna",
    "option_c": "Whitney Houston",
    "option_d": "Janet Jackson",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 30,
    "theme_id": 2,
    "question_text": "Which band is known for the song \"Stairway to Heaven\"?",
    "option_a": "Pink Floyd",
    "option_b": "Led Zeppelin",
    "option_c": "Deep Purple",
    "option_d": "Black Sabbath",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades"
  },
  {
    "id": 31,
    "theme_id": 3,
    "question_text": "What social media platform launched in 2004?",
    "option_a": "Twitter",
    "option_b": "MySpace",
    "option_c": "Facebook",
    "option_d": "Instagram",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 32,
    "theme_id": 3,
    "question_text": "Which phone was released by Apple in 2007?",
    "option_a": "iPod Touch",
    "option_b": "iPhone",
    "option_c": "iPad",
    "option_d": "Blackberry",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 34,
    "theme_id": 3,
    "question_text": "Which TV show featured the characters Jack, Kate, and Sawyer on a mysterious island?",
    "option_a": "Survivor",
    "option_b": "Lost",
    "option_c": "The OC",
    "option_d": "Heroes",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 36,
    "theme_id": 3,
    "question_text": "Which movie franchise began with \"The Fellowship of the Ring\" in 2001?",
    "option_a": "Harry Potter",
    "option_b": "The Matrix",
    "option_c": "Lord of the Rings",
    "option_d": "Star Wars Prequels",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 37,
    "theme_id": 3,
    "question_text": "What portable music player dominated the 2000s?",
    "option_a": "Zune",
    "option_b": "Walkman",
    "option_c": "iPod",
    "option_d": "MiniDisc",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 38,
    "theme_id": 3,
    "question_text": "Which reality TV show first aired in 2002 and featured Simon Cowell?",
    "option_a": "The Voice",
    "option_b": "American Idol",
    "option_c": "X Factor",
    "option_d": "America's Got Talent",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 40,
    "theme_id": 3,
    "question_text": "Which video platform launched in 2005?",
    "option_a": "Vimeo",
    "option_b": "YouTube",
    "option_c": "Dailymotion",
    "option_d": "Twitch",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 42,
    "theme_id": 3,
    "question_text": "Which animated movie featured a clownfish searching for his son?",
    "option_a": "Shark Tale",
    "option_b": "Finding Nemo",
    "option_c": "The Little Mermaid 2",
    "option_d": "SpongeBob Movie",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 43,
    "theme_id": 3,
    "question_text": "What was Tom from MySpace famous for?",
    "option_a": "Creating viral videos",
    "option_b": "Being everyone's first friend",
    "option_c": "Inventing hashtags",
    "option_d": "Starting Facebook",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 44,
    "theme_id": 3,
    "question_text": "Which gaming console did Nintendo release in 2006?",
    "option_a": "GameCube",
    "option_b": "Nintendo DS",
    "option_c": "Wii",
    "option_d": "Switch",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 45,
    "theme_id": 3,
    "question_text": "What low-rise fashion trend was everywhere in the early 2000s?",
    "option_a": "Bell bottoms",
    "option_b": "Low-rise jeans",
    "option_c": "Cargo pants",
    "option_d": "Skinny jeans",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia"
  },
  {
    "id": 46,
    "theme_id": 4,
    "question_text": "What planet is known as the Red Planet?",
    "option_a": "Venus",
    "option_b": "Mars",
    "option_c": "Jupiter",
    "option_d": "Saturn",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 47,
    "theme_id": 4,
    "question_text": "What is the chemical symbol for water?",
    "option_a": "H2O",
    "option_b": "CO2",
    "option_c": "O2",
    "option_d": "NaCl",
    "correct_answer": "A",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 50,
    "theme_id": 4,
    "question_text": "What gas do plants absorb from the atmosphere?",
    "option_a": "Oxygen",
    "option_b": "Nitrogen",
    "option_c": "Carbon dioxide",
    "option_d": "Hydrogen",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 52,
    "theme_id": 4,
    "question_text": "Which element has the atomic number 1?",
    "option_a": "Helium",
    "option_b": "Hydrogen",
    "option_c": "Oxygen",
    "option_d": "Carbon",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 53,
    "theme_id": 4,
    "question_text": "What is the hardest natural substance on Earth?",
    "option_a": "Granite",
    "option_b": "Quartz",
    "option_c": "Diamond",
    "option_d": "Topaz",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature"
  },
  {
    "id": 56,
    "theme_id": 5,
    "question_text": "How many rings did Michael Jordan win with the Chicago Bulls?",
    "option_a": "4",
    "option_b": "5",
    "option_c": "6",
    "option_d": "7",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 58,
    "theme_id": 5,
    "question_text": "In what sport would you perform a \"slam dunk\"?",
    "option_a": "Football",
    "option_b": "Basketball",
    "option_c": "Tennis",
    "option_d": "Volleyball",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 61,
    "theme_id": 5,
    "question_text": "What is the length of a marathon in miles (approx)?",
    "option_a": "20.2",
    "option_b": "24.2",
    "option_c": "26.2",
    "option_d": "28.2",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 62,
    "theme_id": 5,
    "question_text": "Which boxer was known as \"The Greatest\"?",
    "option_a": "Mike Tyson",
    "option_b": "Sugar Ray Leonard",
    "option_c": "Muhammad Ali",
    "option_d": "Floyd Mayweather",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends"
  },
  {
    "id": 67,
    "theme_id": 6,
    "question_text": "What is the main ingredient in guacamole?",
    "option_a": "Tomato",
    "option_b": "Avocado",
    "option_c": "Lime",
    "option_d": "Jalapeño",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 68,
    "theme_id": 6,
    "question_text": "What type of pasta is shaped like small tubes?",
    "option_a": "Spaghetti",
    "option_b": "Fettuccine",
    "option_c": "Penne",
    "option_d": "Linguine",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 69,
    "theme_id": 6,
    "question_text": "Which spirit is the main ingredient in a Margarita?",
    "option_a": "Rum",
    "option_b": "Vodka",
    "option_c": "Tequila",
    "option_d": "Gin",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 71,
    "theme_id": 6,
    "question_text": "Sushi originated in which country?",
    "option_a": "China",
    "option_b": "Japan",
    "option_c": "Korea",
    "option_d": "Thailand",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 72,
    "theme_id": 6,
    "question_text": "What gives bread its rise?",
    "option_a": "Baking soda",
    "option_b": "Yeast",
    "option_c": "Salt",
    "option_d": "Sugar",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 73,
    "theme_id": 6,
    "question_text": "Which cheese is traditionally used on a Margherita pizza?",
    "option_a": "Cheddar",
    "option_b": "Parmesan",
    "option_c": "Mozzarella",
    "option_d": "Gouda",
    "correct_answer": "C",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  },
  {
    "id": 74,
    "theme_id": 6,
    "question_text": "What fruit is used to make wine?",
    "option_a": "Apple",
    "option_b": "Grape",
    "option_c": "Cherry",
    "option_d": "Pear",
    "correct_answer": "B",
    "difficulty": "easy",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink"
  }
]
```

## [PASS] POST /api/questions
- **Description:** Create question no auth -> 401
- **Expected status:** 401
- **Received status:** 401
- **Request body:**
```json
{
  "theme_id": 10
}
```
- **Response body:**
```json
{
  "error": "No token provided"
}
```

## [PASS] POST /api/questions
- **Description:** Create question missing fields -> 400
- **Expected status:** 400
- **Received status:** 400
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "theme_id": 10,
  "question_text": "x"
}
```
- **Response body:**
```json
{
  "error": "All question fields are required"
}
```

## [PASS] POST /api/questions
- **Description:** Invalid correct_answer Z -> 400
- **Expected status:** 400
- **Received status:** 400
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "theme_id": 10,
  "question_text": "Q?",
  "option_a": "a",
  "option_b": "b",
  "option_c": "c",
  "option_d": "d",
  "correct_answer": "Z"
}
```
- **Response body:**
```json
{
  "error": "correct_answer must be A, B, C, or D"
}
```

## [PASS] POST /api/questions
- **Description:** Create question valid (lowercase b) -> 201
- **Expected status:** 201
- **Received status:** 201
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "theme_id": 10,
  "question_text": "2+2?",
  "option_a": "3",
  "option_b": "4",
  "option_c": "5",
  "option_d": "6",
  "correct_answer": "b",
  "difficulty": "easy"
}
```
- **Response body:**
```json
{
  "id": 76,
  "theme_id": 10,
  "question_text": "2+2?",
  "option_a": "3",
  "option_b": "4",
  "option_c": "5",
  "option_d": "6",
  "correct_answer": "B",
  "difficulty": "easy",
  "is_active": 1,
  "created_at": "2026-04-05T18:14:02.000Z",
  "updated_at": "2026-04-05T18:14:02.000Z"
}
```

## [PASS] POST /api/questions
- **Description:** Create question bad FK theme_id -> 500 (FK violation)
- **Expected status:** 500
- **Received status:** 500
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "theme_id": 999999,
  "question_text": "x",
  "option_a": "a",
  "option_b": "b",
  "option_c": "c",
  "option_d": "d",
  "correct_answer": "A"
}
```
- **Response body:**
```json
{
  "error": "Server error"
}
```

## [PASS] POST /api/questions
- **Description:** SQL injection in question text -> 201 (safely escaped)
- **Expected status:** 201
- **Received status:** 201
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "theme_id": 10,
  "question_text": "'; DROP TABLE questions; --",
  "option_a": "a",
  "option_b": "b",
  "option_c": "c",
  "option_d": "d",
  "correct_answer": "A"
}
```
- **Response body:**
```json
{
  "id": 78,
  "theme_id": 10,
  "question_text": "'; DROP TABLE questions; --",
  "option_a": "a",
  "option_b": "b",
  "option_c": "c",
  "option_d": "d",
  "correct_answer": "A",
  "difficulty": "medium",
  "is_active": 1,
  "created_at": "2026-04-05T18:14:02.000Z",
  "updated_at": "2026-04-05T18:14:02.000Z"
}
```

## [PASS] GET /api/questions/76
- **Description:** Get single question
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
{
  "id": 76,
  "theme_id": 10,
  "question_text": "2+2?",
  "option_a": "3",
  "option_b": "4",
  "option_c": "5",
  "option_d": "6",
  "correct_answer": "B",
  "difficulty": "easy",
  "is_active": 1,
  "created_at": "2026-04-05T18:14:02.000Z",
  "updated_at": "2026-04-05T18:14:02.000Z",
  "theme_name": "QTheme_1775412842059"
}
```

## [PASS] GET /api/questions/999999
- **Description:** Get nonexistent question -> 404
- **Expected status:** 404
- **Received status:** 404
- **Response body:**
```json
{
  "error": "Question not found"
}
```

## [PASS] PUT /api/questions/76
- **Description:** Update question correct_answer
- **Expected status:** 200
- **Received status:** 200
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "correct_answer": "c"
}
```
- **Response body:**
```json
{
  "id": 76,
  "theme_id": 10,
  "question_text": "2+2?",
  "option_a": "3",
  "option_b": "4",
  "option_c": "5",
  "option_d": "6",
  "correct_answer": "C",
  "difficulty": "easy",
  "is_active": 1,
  "created_at": "2026-04-05T18:14:02.000Z",
  "updated_at": "2026-04-05T18:14:02.000Z"
}
```

## [PASS] PUT /api/questions/76
- **Description:** Update question no fields -> 400
- **Expected status:** 400
- **Received status:** 400
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{}
```
- **Response body:**
```json
{
  "error": "No fields to update"
}
```

## [PASS] DELETE /api/questions/76
- **Description:** Delete question no auth -> 401
- **Expected status:** 401
- **Received status:** 401
- **Response body:**
```json
{
  "error": "No token provided"
}
```

## [PASS] DELETE /api/questions/76
- **Description:** Delete question (soft) -> 200
- **Expected status:** 200
- **Received status:** 200
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Response body:**
```json
{
  "message": "Question deactivated"
}
```

## [PASS] GET /api/events
- **Description:** List events (public)
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
[
  {
    "id": 1,
    "theme_id": 1,
    "title": "Presidents Day History Night",
    "event_date": "2026-02-19T07:00:00.000Z",
    "start_time": "19:00:00",
    "max_teams": 30,
    "max_players_per_team": 5,
    "question_count": 15,
    "time_limit_seconds": 30,
    "status": "published",
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "American History",
    "available_questions": 15
  },
  {
    "id": 2,
    "theme_id": 2,
    "title": "Rock & Roll Through the Ages",
    "event_date": "2026-02-24T07:00:00.000Z",
    "start_time": "19:30:00",
    "max_teams": 30,
    "max_players_per_team": 5,
    "question_count": 15,
    "time_limit_seconds": 30,
    "status": "published",
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Music Through the Decades",
    "available_questions": 15
  },
  {
    "id": 3,
    "theme_id": 3,
    "title": "Totally 2000s Throwback Night",
    "event_date": "2026-02-26T07:00:00.000Z",
    "start_time": "19:00:00",
    "max_teams": 30,
    "max_players_per_team": 5,
    "question_count": 15,
    "time_limit_seconds": 25,
    "status": "draft",
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia",
    "available_questions": 15
  },
  {
    "id": 4,
    "theme_id": 6,
    "title": "Pub Grub & Brews Trivia",
    "event_date": "2026-03-03T07:00:00.000Z",
    "start_time": "20:00:00",
    "max_teams": 25,
    "max_players_per_team": 5,
    "question_count": 10,
    "time_limit_seconds": 30,
    "status": "draft",
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink",
    "available_questions": 10
  },
  {
    "id": 5,
    "theme_id": 5,
    "title": "March Madness Sports Trivia",
    "event_date": "2026-03-10T06:00:00.000Z",
    "start_time": "19:00:00",
    "max_teams": 30,
    "max_players_per_team": 5,
    "question_count": 15,
    "time_limit_seconds": 30,
    "status": "draft",
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends",
    "available_questions": 10
  },
  {
    "id": 6,
    "theme_id": 4,
    "title": "Science Night at The Cellar Door",
    "event_date": "2026-03-17T06:00:00.000Z",
    "start_time": "19:00:00",
    "max_teams": 30,
    "max_players_per_team": 5,
    "question_count": 10,
    "time_limit_seconds": 35,
    "status": "draft",
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature",
    "available_questions": 10
  }
]
```

## [PASS] GET /api/events?status=draft
- **Description:** List events filtered by status=draft
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
[
  {
    "id": 3,
    "theme_id": 3,
    "title": "Totally 2000s Throwback Night",
    "event_date": "2026-02-26T07:00:00.000Z",
    "start_time": "19:00:00",
    "max_teams": 30,
    "max_players_per_team": 5,
    "question_count": 15,
    "time_limit_seconds": 25,
    "status": "draft",
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "2000s Nostalgia",
    "available_questions": 15
  },
  {
    "id": 4,
    "theme_id": 6,
    "title": "Pub Grub & Brews Trivia",
    "event_date": "2026-03-03T07:00:00.000Z",
    "start_time": "20:00:00",
    "max_teams": 25,
    "max_players_per_team": 5,
    "question_count": 10,
    "time_limit_seconds": 30,
    "status": "draft",
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Food & Drink",
    "available_questions": 10
  },
  {
    "id": 5,
    "theme_id": 5,
    "title": "March Madness Sports Trivia",
    "event_date": "2026-03-10T06:00:00.000Z",
    "start_time": "19:00:00",
    "max_teams": 30,
    "max_players_per_team": 5,
    "question_count": 15,
    "time_limit_seconds": 30,
    "status": "draft",
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Sports Legends",
    "available_questions": 10
  },
  {
    "id": 6,
    "theme_id": 4,
    "title": "Science Night at The Cellar Door",
    "event_date": "2026-03-17T06:00:00.000Z",
    "start_time": "19:00:00",
    "max_teams": 30,
    "max_players_per_team": 5,
    "question_count": 10,
    "time_limit_seconds": 35,
    "status": "draft",
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "theme_name": "Science & Nature",
    "available_questions": 10
  }
]
```

## [PASS] POST /api/events
- **Description:** Create event no auth -> 401
- **Expected status:** 401
- **Received status:** 401
- **Request body:**
```json
{
  "theme_id": 10,
  "title": "x",
  "event_date": "2026-12-31"
}
```
- **Response body:**
```json
{
  "error": "No token provided"
}
```

## [PASS] POST /api/events
- **Description:** Create event missing theme_id/event_date -> 400
- **Expected status:** 400
- **Received status:** 400
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "title": "incomplete"
}
```
- **Response body:**
```json
{
  "error": "theme_id, title, and event_date are required"
}
```

## [PASS] POST /api/events
- **Description:** Create event valid -> 201
- **Expected status:** 201
- **Received status:** 201
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "theme_id": 10,
  "title": "Test Event 1775412842236",
  "event_date": "2026-12-31",
  "start_time": "20:00:00",
  "max_teams": 10
}
```
- **Response body:**
```json
{
  "id": 7,
  "theme_id": 10,
  "title": "Test Event 1775412842236",
  "event_date": "2026-12-31T07:00:00.000Z",
  "start_time": "20:00:00",
  "max_teams": 10,
  "max_players_per_team": 5,
  "question_count": 10,
  "time_limit_seconds": 30,
  "status": "draft",
  "created_at": "2026-04-05T18:14:02.000Z",
  "updated_at": "2026-04-05T18:14:02.000Z"
}
```

## [PASS] POST /api/events
- **Description:** Create event bad FK theme_id -> 500
- **Expected status:** 500
- **Received status:** 500
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "theme_id": 999999,
  "title": "BadFK",
  "event_date": "2026-12-31"
}
```
- **Response body:**
```json
{
  "error": "Server error"
}
```

## [PASS] GET /api/events/7
- **Description:** Get single event
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
{
  "id": 7,
  "theme_id": 10,
  "title": "Test Event 1775412842236",
  "event_date": "2026-12-31T07:00:00.000Z",
  "start_time": "20:00:00",
  "max_teams": 10,
  "max_players_per_team": 5,
  "question_count": 10,
  "time_limit_seconds": 30,
  "status": "draft",
  "created_at": "2026-04-05T18:14:02.000Z",
  "updated_at": "2026-04-05T18:14:02.000Z",
  "theme_name": "QTheme_1775412842059"
}
```

## [PASS] GET /api/events/999999
- **Description:** Get nonexistent event -> 404
- **Expected status:** 404
- **Received status:** 404
- **Response body:**
```json
{
  "error": "Event not found"
}
```

## [PASS] PUT /api/events/7
- **Description:** Update event no auth -> 401
- **Expected status:** 401
- **Received status:** 401
- **Request body:**
```json
{
  "title": "x"
}
```
- **Response body:**
```json
{
  "error": "No token provided"
}
```

## [PASS] PUT /api/events/7
- **Description:** Update event bad JWT -> 401
- **Expected status:** 401
- **Received status:** 401
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "title": "x"
}
```
- **Response body:**
```json
{
  "error": "Invalid token"
}
```

## [PASS] PUT /api/events/7
- **Description:** Update event malformed header -> 401
- **Expected status:** 401
- **Received status:** 401
- **Auth header:** `Malformed`
- **Request body:**
```json
{
  "title": "y"
}
```
- **Response body:**
```json
{
  "error": "Invalid token"
}
```

## [PASS] PUT /api/events/7
- **Description:** Update event title+status
- **Expected status:** 200
- **Received status:** 200
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{
  "title": "Updated Title",
  "status": "published"
}
```
- **Response body:**
```json
{
  "id": 7,
  "theme_id": 10,
  "title": "Updated Title",
  "event_date": "2026-12-31T07:00:00.000Z",
  "start_time": "20:00:00",
  "max_teams": 10,
  "max_players_per_team": 5,
  "question_count": 10,
  "time_limit_seconds": 30,
  "status": "published",
  "created_at": "2026-04-05T18:14:02.000Z",
  "updated_at": "2026-04-05T18:14:02.000Z"
}
```

## [PASS] PUT /api/events/7
- **Description:** Update event no fields -> 400
- **Expected status:** 400
- **Received status:** 400
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Request body:**
```json
{}
```
- **Response body:**
```json
{
  "error": "No fields to update"
}
```

## [PASS] DELETE /api/events/7
- **Description:** Delete event no auth -> 401
- **Expected status:** 401
- **Received status:** 401
- **Response body:**
```json
{
  "error": "No token provided"
}
```

## [PASS] DELETE /api/events/7
- **Description:** Delete event (cancel) -> 200
- **Expected status:** 200
- **Received status:** 200
- **Auth header:** `Bearer eyJhbGciOiJIU...[truncated]`
- **Response body:**
```json
{
  "message": "Event cancelled"
}
```

## [PASS] GET /api/events?status=draft' OR '1'='1
- **Description:** SQL injection in status filter -> 200 with empty results
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
[]
```

## [PASS] GET /api/themes
- **Description:** Public GET themes (no auth req)
- **Expected status:** 200
- **Received status:** 200
- **Response body:**
```json
[
  {
    "id": 3,
    "name": "2000s Nostalgia",
    "description": "Pop culture, tech, TV shows, and trends from the Y2K decade.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 15
  },
  {
    "id": 1,
    "name": "American History",
    "description": "From the Revolution to modern day — test your knowledge of U.S. history.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 15
  },
  {
    "id": 6,
    "name": "Food & Drink",
    "description": "Culinary trivia from around the world — perfect for a pub night.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 10
  },
  {
    "id": 2,
    "name": "Music Through the Decades",
    "description": "Hits, artists, and moments that defined each era of music.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 15
  },
  {
    "id": 10,
    "name": "QTheme_1775412842059",
    "description": null,
    "is_active": 1,
    "created_at": "2026-04-05T18:14:02.000Z",
    "updated_at": "2026-04-05T18:14:02.000Z",
    "question_count": 1
  },
  {
    "id": 9,
    "name": "Robert'); DROP TABLE themes;--",
    "description": null,
    "is_active": 1,
    "created_at": "2026-04-05T18:14:01.000Z",
    "updated_at": "2026-04-05T18:14:01.000Z",
    "question_count": 0
  },
  {
    "id": 4,
    "name": "Science & Nature",
    "description": "The natural world, space, chemistry, and everything in between.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 10
  },
  {
    "id": 5,
    "name": "Sports Legends",
    "description": "Iconic athletes, championship moments, and record-breakers.",
    "is_active": 1,
    "created_at": "2026-02-19T18:31:20.000Z",
    "updated_at": "2026-02-19T18:31:20.000Z",
    "question_count": 10
  },
  {
    "id": 7,
    "name": "TestTheme_1775412841955",
    "description": "Updated description",
    "is_active": 1,
    "created_at": "2026-04-05T18:14:01.000Z",
    "updated_at": "2026-04-05T18:14:02.000Z",
    "question_count": 0
  }
]
```

## [PASS] POST /api/themes
- **Description:** Create theme empty bearer -> 401
- **Expected status:** 401
- **Received status:** 401
- **Auth header:** `Bearer `
- **Request body:**
```json
{
  "name": "EmptyTok"
}
```
- **Response body:**
```json
{
  "error": "Invalid token"
}
```