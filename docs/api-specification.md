# REST API 仕様

## 共通項目
* API のアクセスには API Token が必要です．
* メニューの 「API トークン一覧」から，API トークンを作成，使用してください．
* API アクセス時は，Query，または Body に "api_key" を含めてください．
* API へのアクセスは，使用した API Token を所有するユーザのアクセスとして認識されます．

* 例
    ```bash
    curl 'https://your.rask.url/tasks.json?api_key=<Your API Key>' # GET
    curl -XPOST -d 'api_key=<Your API Key>' 'https://your.rask.url/tasks.json' # POST (or PUT, DELETE)
    ```

* Response は以下の通りです．
    * 200 (Ok): Request は正常に処理されました．
    * 400 (Bad Request): Requst Body に不正なデータが含まれています． 
    * 401 (Unauthorized): API Token が付与されていないか，不正です．
    * 403 (Forbidden): 認証されたユーザの権限では，リクエストを処理できません．
    * 404 (Not Found): 指定された PATH に対応する API が存在しないか，指定されたリソースが存在しません．

## Task
### Request Schema
```
TaskRequest {
    (require) "assigner_id":   Integer,
    (require) "content":       String,
              "due_at":        Datetime,
              "description":   String,
              "project_id":    Integer,
              "task_state_id": Integer,
              "tag_names":     List<String>
}
```

### Response Schema
```
TaskResponse {
    "id":          Iteger,
    "content":     String,
    "description": String,
    "due_at":      Daetime,
    "created_at":  Datetime,
    "updated_at":  Datetime,
    "creator": {
        "id":      Integer,
        "name":    String,
    },
    "assigner": {
        "id":      Integer,
        "name":    String,
    },
    "project": {
        "id":      Integer,
        "name":    String,
    },
    "url":         String,
}
```

### API
1. Show all tasks
    * Method: GET
    * PATH: "/tasks.json"
    * Request: -
    * Response: List<TaskResponse>
2. Show a task
    * Method: GET
    * PATH: "/tasks/<Task ID>.json" ("/tasks/1.json")
    * Request: -
    * Response: TaskResponse
3. Create new task
    * Method: POST
    * PATH: "/tasks.json"
    * Request: TaskRequest
    * Response: TaskResponse (newly-created task)
4. Edit a task
    * Method: PUT or PATCH
    * PATH: "/tasks.json"
    * Request: TaskRequest
    * Response: TaskResponse (editted task)
5. Delete a task
    * Method: DELETE
    * PATH: "/tasks/<Task ID>.json" ("/tasks/1.json")
    * Request: -
    * Response: TaskResponse (deleted task)

## Document
### Request Schema
```
DocumentRequest {
    (require) "content":     String
              "description": String
              "project_id":  Integer
              "start_at":    Datetime
              "end_at":      Datetime
              "location":    String
              "tag_names":   List<String>
}

```

### Response Schema
```
DocumentResponse {
    "id":          Integer,
    "content":     String,
    "creator_id":  Integer,
    "description": String,
    "created_at":  Datetime,
    "updated_at":  Datetime,
    "project_id":  Integer,
    "start_at":    Datetime,
    "end_at":      Datetime,
    "location":    Integer,
    "Tag":         List<String>,
    "url":         String,
}
```

### API
1. Show all documents
    * Method: GET
    * PATH: "/documents.json"
    * Request: -
    * Response: List<DocumentResponse>
2. Show a document
    * Method: GET
    * PATH: "/documents/<Document ID>.json" ("/documents/1.json")
    * Request: -
    * Response: DocumentResponse
3. Create new document
    * Method: POST
    * PATH: "/documents.json"
    * Request: DocumentRequest
    * Response: DocumentResponse (newly-created document)
4. Edit a document
    * Method: PUT or PATCH
    * PATH: "/documents/<Document ID>.json" ("/documents/1.json")
    * Request: DocumentRequest
    * Response: DocumentResponse (editted document)
5. Delete a document
    * Method: DELETE
    * PATH: "/documents/<Document ID>.json" ("/documents/1.json")
    * Request: -
    * Response: DocumentResponse (deleted document)

## User
### Request Schema
```
UserRequest {
    (require) "name":        String,
    (require) "active":      Bool,
    (require) "screen_name": String,
}
```

### Response Schema
```
UserResponse {
    "id":          Integer,
    "name":        String,
    "active":      Bool,
    "screen_name": String,
    "created_at":  Datetime,
    "updated_at":  Datetime,
    "url":         String,
}
```

### API
1. Show all users
    * Method: GET
    * PATH: "/users.json"
    * Request: -
    * Response: List<UserResponse>
2. Show a user
    * Method: GET
    * PATH: "/users/<User ID>.json" ("/users/1.json")
    * Request: -
    * Response: UserResponse
3. ~~Create new user~~
    * Cannot create user with API
4. Edit a user
    * Method: PUT or PATCH
    * PATH: "/users/<User ID>.json" ("/users/1.json")
    * Request: UserRequest
    * Response: UserResponse (editted user)
    * Note: You can edit only your account.
5. Delete a user
    * Method: DELETE
    * PATH: "/users/<User ID>.json" ("/users/1.json")
    * Request: -
    * Response: UserResponse (deleted user)
    * Note: You can delete only your account.

## Project
### Request Schema
```
ProjectRequest {
    (require) "name": String,
}
```

### Response Schema
```
ProjectResponse {
    "id":         Integer,
    "name":       String,
    "created_at": Datetime,
    "updated_at": Datetime,
    "user": {
        "id":     Integer,
        "name":   String,
    },
    "url":        String,
}
```

### API
1. Show all projects
    * Method: GET
    * PATH: "/projects.json"
    * Request: -
    * Response: List<ProjectResponse>
2. Show a project
    * Method: GET
    * PATH: "/projects/<Project ID>.json" ("/projects/1.json")
    * Request: -
    * Response: ProjectResponse
3. Create new project
    * Method: POST
    * PATH: "/projects.json"
    * Request: ProjectRequest
    * Response: ProjectResponse (newly-created project)
4. Edit a project
    * Method: PUT or PATCH
    * PATH: "/projects/<Project ID>.json" ("/projects/1.json")
    * Request: ProjectRequest
    * Response: ProjectResponse (editted project)
5. Delete a project
    * Method: DELETE
    * PATH: "/projects/<Project ID>.json" ("/projects/1.json")
    * Request: -
    * Response: ProjectResponse (deleted project)
    * Note: If specified project has some tasks, you cannot delete.

## Tag
### Request Schema
```
TagRequest {
    (require) name: String,
}
```

### Response Schema
```
TagResponse {
    "id":         Integer,
    "name":       String,
    "created_at": Datetime,
    "updated_at": Datetime,
    "url":        String,
}
```

### API
1. Show all tags
    * Method: GET
    * PATH: "/tags.json"
    * Request: -
    * Response: List<TagResponse>
2. Show a tag
    * Method: GET
    * PATH: "/tags/<tag ID>.json" ("/tags/1.json")
    * Request: -
    * Response:  TagResponse
3. Create new tag
    * Method: POST
    * PATH: "/tags.json"
    * Request: TagResponse
    * Response: TagResponse (newly-created tag)
4. Edit a tag
    * Method: PUT or PATCH
    * PATH: "/tags.json"
    * Request: TagResponse
    * Response: TagResponse (editted tag)
5. Delete a tag
    * Method: DELETE
    * PATH: "/tags/<tag ID>.json" ("/tags/1.json")
    * Request: -
    * Response: TagResponse (deleted tag)
    * Note: If specified tag has some tasks, you cannot delete.

## API Token
### Request Schema
```
APITokenRequest {
    (require) description: String,
}
```

### Response Schema
```
APITokenResponse {
    "id":          Integer,
    "secret":      String,
    "description": String,
    "expired_at":  Datetime,
    "created_at":  Datetime,
    "updated_at":  Datetime,
    "user": {
        "id":      Integer,
        "name":    String,
    },
    "url":         String,
}
```

### API
1. Show all your API tokens
    * Method: GET
    * PATH: "/api_tokens.json"
    * Request: -
    * Response: List<APITokenResponse>
    * Note: You can show only your API Tokens
2. Show a API token
    * Method: GET
    * PATH: "/api_tokens/<API Token ID>.json" ("/api_tokens/1.json")
    * Request: -
    * Response: APITokenResponse
    * Note: You can show only your API Token
3. Create new task
    * Method: POST
    * PATH: "/tasks.json"
    * Request: APITokenRequest
    * Response: APITokenResponse (newly-created API Token)
    * Note: New task is owned by your account.
4. Edit a API Token
    * Method: PUT or PATCH
    * PATH: "/api_tokens/<API Token ID>.json" ("/api_tokens/1.json")
    * Request: APITokenRequest
    * Response: APITokenResponse (editted API Token)
    * Note: You can edit only your API Token
5. Delete a API token
    * Method: DELETE
    * PATH: "/api_tokens/<API Token ID>.json" ("/api_tokens/1.json")
    * Request: -
    * Response: APITokenResponse (deleted API Token)
    * Note: You can delete only your API Token

