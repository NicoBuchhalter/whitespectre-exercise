Whitespectre Exercise - Documentation
===============

## Users

### Create

Creates a new User

``` 
POST /users
```

- Parameters:
    - `email`: required, string, must be unique. Also, it must have a valid email format.
    - `name`: optional, string.

In case the User was created, the answer will have a status code 201 (Created) and a body representing the user: 

```json
{
    "user": {
        "id": 7,
        "name": "Whitespectre User",
        "email": "whitespectre-doc@example.com"
    }
}
```

Otherwise, it will respond with a status code 400 (Bad Request), specifying the errors in the response. For example: 

```json
{
    "errors": {
        "email": [
            "has already been taken"
        ]
    }
}
```


### Index

Returns a paginated list of all users. Status code 200 (Ok).

``` 
GET /users
```

- Parameters:
    - `page`: optional, integer. Page number you desire to fetch. First page is 1.
    - `per_page`: optional, integer. Amount of records per page. Default is 5.


Response:

```json
{
    "users": [
        {
            "id": 8,
            "name": "Darrel Cruickshank",
            "email": "giovanni@huelconroy.biz"
        },
        {
            "id": 9,
            "name": "Stevie Quigley",
            "email": "michale.runolfon@fadel.name"
        },
        {
            "id": 10,
            "name": "Miss Maria Breitenberg",
            "email": "tim_johns@gorczany.co"
        },
        {
            "id": 11,
            "name": "Rhea Davis",
            "email": "leslie_orn@loweterry.info"
        },
        {
            "id": 12,
            "name": "Sharlene Stroman",
            "email": "alton.langosh@beahan.net"
        }
    ],
    "meta": {
        "current_page": 1,
        "current_page_count": 5,
        "total_count": 13,
        "total_pages": 3,
        "per_page": 5
    }
}
```

### Show

Fetchs one User by ID

``` 
GET /users/:id
```

If a User with the ID exists, it returs the User, with status code 200 (Ok).

```json
{
    "user": {
        "id": 10,
        "name": "Miss Maria Breitenberg",
        "email": "tim_johns@gorczany.co"
    }
}
```

Otherwise, it returns a 404 status code (Not Found).


## Group Events

### Create

Creates a new GroupEvent

``` 
POST /group_events
```

- Parameters:
    - `creator_id`: required, integer. A user with this ID must exist.
    - `name`: optional, string.
    - `description`: optional, text.
    - `location`: optional, string.
    - `start_date`: optional, date (string with format YYYY-MM-DD). Must be previous than `end_date`
    - `end_date`: optional, date (string with format YYYY-MM-DD). Must be posterior than `start_date`
    - `duration`: optional, integer representing amount of days. If both or none of `start_date` and `end_date` were provided, it will be ignored. If only one of them was provided, it will calculate the other.


In case the GroupEvent was created, the answer will have a status code 201 (Created) and a body representing the event: 

```json
{
    "group_event": {
        "id": 63,
        "name": "Example GroupEvent",
        "published": false,
        "description": "This is the event of the documentation example",
        "start_date": "2019-10-20",
        "end_date": "2019-10-23",
        "duration": 3,
        "location": "Whitespectre HQ in Barcelona",
        "creator": {
            "id": 10,
            "name": "Miss Maria Breitenberg",
            "email": "tim_johns@gorczany.co"
        }
    }
}
```

Otherwise, it will respond with a status code 400 (Bad Request), specifying the errors in the response. For example: 

```json
{
    "errors": {
        "creator": [
            "must exist"
        ] 
    }
}
```


### Index

Returns a paginated list of all events. Status code 200 (Ok).

``` 
GET /group_events
```

- Parameters:
    - `published`: optional, `true` or any other thing. If this parameter is passed with value "true", it will filter by published events. Otherwise, it will return all of them.
    - `page`: optional, integer. Page number you desire to fetch. First page is 1.
    - `per_page`: optional, integer. Amount of records per page. Default is 5.


Response:

```json
{
    "group_events": [
        {
            "id": 40,
            "name": "Brice Reynolds",
            "published": false,
            "description": "Cum aut veritatis. Incidunt qui consequuntur. Et nihil sint.",
            "start_date": "2019-10-18",
            "end_date": "2019-10-30",
            "duration": 12,
            "location": "244 Hermiston Park, Batzstad, MO 77502",
            "creator": {
                "id": 17,
                "name": "Eugenio Walker I",
                "email": "harris.goldner@mckenziecartwright.net"
            }
        },
        {
            "id": 41,
            "name": "Larae Beer",
            "published": false,
            "description": "Assumenda illo ut. Unde veniam necessitatibus. Eos est velit.",
            "start_date": "2019-10-18",
            "end_date": "2019-11-01",
            "duration": 14,
            "location": "305 Allyn Plain, Greenfelderberg, OR 92303-6039",
            "creator": {
                "id": 17,
                "name": "Eugenio Walker I",
                "email": "harris.goldner@mckenziecartwright.net"
            }
        }
    ],
    "meta": {
        "current_page": 1,
        "current_page_count": 2,
        "total_count": 24,
        "total_pages": 12,
        "per_page": 2
    }
}
```

### Show

Fetchs one GroupEvent by ID

``` 
GET /group_events/:id
```

If a GroupEvent with the ID exists, it returs the event, with status code 200 (Ok).

```json
{
    "group_event": {
        "id": 63,
        "name": "Example GroupEvent",
        "published": false,
        "description": "This is the event of the documentation example",
        "start_date": "2019-10-20",
        "end_date": "2019-10-23",
        "duration": 3,
        "location": "Whitespectre HQ in Barcelona",
        "creator": {
            "id": 10,
            "name": "Miss Maria Breitenberg",
            "email": "tim_johns@gorczany.co"
        }
    }
}
```

Otherwise, it returns a 404 status code (Not Found).


### Update

Updates an event's attributes. 

``` 
PUT /group_events/:id
```

- Parameters: It receives the same parameters than in the #create endpoint, but none is required. You can pass just the ones you want to modify.
- Duration, start date and end date can be modified following the same logic than in the creation.

In case the GroupEvent existed and upadte didn't fail, the answer will have a status code 200 (Ok) and a body representing the updated event: 

```json
{
    "group_event": {
        "id": 63,
        "name": "Updated Event",
        "published": false,
        "description": "This is an event that had its name, description and start date modified",
        "start_date": "2019-10-15",
        "end_date": "2019-10-23",
        "duration": 8,
        "location": "Whitespectre HQ in Barcelona",
        "creator": {
            "id": 10,
            "name": "Miss Maria Breitenberg",
            "email": "tim_johns@gorczany.co"
        }
    }
}
```

Otherwise, it will respond with a status code 400 (Bad Request), specifying the errors in the response. For example: 

```json
{   
    "errors": {
        "start_date": [
            "Must be previous or equal than end date"
        ]     
    }
}
```

If an event with the requested ID doesn't exist, it will return a status code 404 (Not found).

### Publish

Publishes an event. Only events which have a name, description, location, start_date and end_date can be published.

``` 
POST /group_events/:id/publish
```

If the event could be published, it will return the event in the response body and a status code 200 (Ok). For Example: 

```json
{
    "group_event": {
        "id": 63,
        "name": "Updated Event",
        "published": true,
        "description": "This is an event that had its name, description and start date modified",
        "start_date": "2019-10-15",
        "end_date": "2019-10-23",
        "duration": 8,
        "location": "Whitespectre HQ in Barcelona",
        "creator": {
            "id": 10,
            "name": "Miss Maria Breitenberg",
            "email": "tim_johns@gorczany.co"
        }
    }
}
```

If not, it will return a status code 400 (Bad Request) and a response body explaining the error: 

```json
{
    "error": "Event needs to have all of required fields to be published"
}
```

If an event with the requested ID doesn't exist, it will return a status code 404 (Not found).

### Destroy

It marks the event as `discarded`. It doesn't delete it from database but you want be able to fetch it by API.

``` 
DELETE /group_events/:id
```
If an event with the ID exists, it will return a status code 200 (Ok).
If not, it will return a status code 404 (Not found).

