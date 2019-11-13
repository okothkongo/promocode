# Promo

This an api for creating promocodes for events offering customers rides from the location to event destination.

his an api for creating promocodes for events offering customers rides from the location to event destination.

  ## Allowed Params and their constraints
  * `number_of_codes` should be an interger and used to generate number of
  promocodes 
  * `amount` should of be a float, it is the total amount offered in all promocodes generated
  * `event_venue` should string with float or integer of longitude and latitude separated in comma i.e `"10, 30.0"`. The first part is latitude and second part is longitude.
  * `end_date` this is the date the event will be held, the date should be in
  `ISO format` that is `YYYY-MM-DD`
  * `status` this is status of a give promocode by default promocode is `active`.
  The allowed status are `deactivated` and `active`.It should be a string
  * `radius` this the maximum distance promocode is operation it is float and the unit is in `metres`
  * `origin` this the location of  a customer(technically it is the promocode location) any given moment.
  The data type and operatons are same are `event_venue`
  * `destination` this is the intended destination of a customer. The data type and operatons are same are `event_venue`
  
  * `code` this unique value given to each promocode, it is a string
 
| purpose                                                 | path                                                                                    | method | params                                                        |
|---------------------------------------------------------|-----------------------------------------------------------------------------------------|--------|---------------------------------------------------------------|
| creating promocodes                                     | http://localhost:4000/api/promocodes                                                    | POST   | number_of_codes, amount, radius, event_venue,  number_of_rides, start_date,  end_date |
| deactivating promocode                                  | http://localhost:4000/api/promocodes/:code                                         | PATCH    | status (should be "inactive" or "active"), radius |
| checking promocode validity | http://localhost:4000/api/promocodes/:code | POST    | origin, destination            |
| view active promocodes                                  | http://localhost:4000/api/promocodes                                     | GET    |   status("active")                                                            |
| view all promocodes                                     | http://localhost:4000/api/promocodes                                                    | GET    |                                                               |
## Request and Response examples

### creating promocodes

`status code 201` incase of success
  request params
    {
      "number_of_codes": 10,
      "event_venue": "10,30",
      "number_of_rides": 3,
      "radius": 3.0,
      "amount": 300,
      "start_date": "2019-10-10",
      "end_date": "2019-10-11"
    }
 
 
  response body is as follows
 
`{
  "amount": 75.0,
  "end_date": "2019-10-11",
  "event_venue": "10,30",
  "number_of_codes": 4,
  "number_of_rides": 3,
  "radius": 3.0,
  "start_date": "2019-10-10"
}
`
 
on failure status will code will be `422` and response be like depending on errors
`    "errors": {
        "amount": [
            "can't be blank"
        ],
        "event_venue": [
            "can't be blank"
        ],
        "end_date": [
            "can't be blank"
        ],
        "number_of_codes": [
            "can't be blank"
        ],
        "number_of_rides": [
            "can't be blank"
        ],
        "start_date": [
            "can't be blank"
        ],
        "radius": [
            "can't be blank"
        ]
    }
}`
### view all promocodes

`status code 200 ` incase of success
 
 response is as follows
 
```
 ["18A9132C6EBC4C6987CBFF6F8140CCD1", "3B3B62AF207A499D8ABB9727D099AE2D",
 "85ECD5D725034F6F96DFB5FAD0522E06", "93B2796E8437410BAD3F9D5AA260A510"]
```

### view active promocodes

  response is follows
 
 ``` 
["18A9132C6EBC4C6987CBFF6F8140CCD1", "3B3B62AF207A499D8ABB9727D099AE2D",
 "85ECD5D725034F6F96DFB5FAD0522E06", "93B2796E8437410BAD3F9D5AA260A510"]
 ```

### checkup promocode validity
 

 
### deactivating status code
`status code 200` incase of success and 
request body
```
{
  "id": 15A30BF75F344D991D8876CEAA7D9E5", "status": "inactive"
}
```
 
 
response body

```
{"amount": 75.0,
    "code": "015A30BF75F344D991D8876CEAA7D9E5",
    "end_date": “2019-10-11”,
    "event_venue": "kisumu",     
    "number_of_codes": 1,
    "number_of_rides": 3,
    "radius": 3.0,
    "start_date": “2019-10-10”,
    "status": "inactive" }

```


 
* kindly note that status can only be `active` or `inactive`
 
 
       
 



This an api for creating promocodes for events offering customers rides from the location to event destination.
 
| purpose                                                 | path                                                                                    | method | params                                                        |
|---------------------------------------------------------|-----------------------------------------------------------------------------------------|--------|---------------------------------------------------------------|
| creating promocodes                                     | http://localhost:4000/api/promocodes                                                    | POST   | number_of_codes, amount, expiry_date, radius, event_venue,  number_of_rides, start_date,  end_date |
| deactivating promocode                                  | http://localhost:4000/api/promocodes/:code                                         | PUT    | status (should be "inactive" or "active"), radius |
| checking promocode validity | http://localhost:4000/api/promocodes/:code | GET    | origin, destination            |
| view active promocodes                                  | http://localhost:4000/api/promocodes                                     | GET    |   status("active")                                                            |
| view all promocodes                                     | http://localhost:4000/api/promocodes                                                    | GET    |                                                               |
## Request and Response examples

### creating promocodes

`status code 201` incase of success
  request params

    {
      "number_of_codes": 10,
      "event_venue": "kisumu",
      "number_of_rides": 3,
      "radius": 3.0,
      "amount": 300,
      "start_date": "2019-10-10",
      "end_date": "2019-10-11"
    }
 
  response body is as follows
 
```{
      "amount": 75.0,
      "end_date": ~D[2019-10-11],
      "event_venue": "kisumu",
      "number_of_codes": 4,
      "number_of_rides": 3,
      "radius": 3.0,
      "start_date": ~D[2019-10-10]
    }
```
 
on failure status will code will be `422` and response be like depending on errors
```    "errors": {
        "amount": [
            "can't be blank"
        ],
        "event_venue": [
            "can't be blank"
        ],
        "end_date": [
            "can't be blank"
        ],
        "number_of_codes": [
            "can't be blank"
        ],
        "number_of_rides": [
            "can't be blank"
        ],
        "start_date": [
            "can't be blank"
        ],
        "radius": [
            "can't be blank"
        ]
    }
}
```
### view all promocodes

`status code 200 ` incase of success
 
 response is as follows
 

 ["18A9132C6EBC4C6987CBFF6F8140CCD1", "3B3B62AF207A499D8ABB9727D099AE2D",
 "85ECD5D725034F6F96DFB5FAD0522E06", "93B2796E8437410BAD3F9D5AA260A510"]
   

 

  ### view active promocodes
  response is follows
 
 
["18A9132C6EBC4C6987CBFF6F8140CCD1", "3B3B62AF207A499D8ABB9727D099AE2D",
 "85ECD5D725034F6F96DFB5FAD0522E06", "93B2796E8437410BAD3F9D5AA260A510"]

 

### checkup promocode validity
 
 
### deactivating status code

`status code 200` incase of success and 
request body
{
  "id": 15A30BF75F344D991D8876CEAA7D9E5", "status": "inactive"
}
 
 
response body
  {
   "amount": 75.0,
      "code": "015A30BF75F344D991D8876CEAA7D9E5",
      "end_date": “2019-10-11”,
      "event_venue": "kisumu",     
      "number_of_codes": 1,
      "number_of_rides": 3,
      "radius": 3.0,
      "start_date": “2019-10-10”,
      "status": "inactive"     
 
}

 
* kindly note that status can only be `active` or `inactive`
 
 
       
 



To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
