**EXTENSION**

# `HTTPNetworkTransport`
```swift
extension HTTPNetworkTransport: NetworkTransport
```

## Methods
### `send(operation:completionHandler:)`

```swift
public func send<Operation: GraphQLOperation>(operation: Operation, completionHandler: @escaping (_ result: Result<GraphQLResponse<Operation.Data>, Error>) -> Void) -> Cancellable
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| operation | The operation to send. |
| completionHandler | A closure to call when a request completes. On `success` will contain the response received from the server. On `failure` will contain the error which occurred. |

### `upload(operation:files:completionHandler:)`

```swift
public func upload<Operation: GraphQLOperation>(operation: Operation,
                                                files: [GraphQLFile],
                                                completionHandler: @escaping (_ result: Result<GraphQLResponse<Operation.Data>, Error>) -> Void) -> Cancellable
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| operation | The operation to send |
| files | An array of `GraphQLFile` objects to send. |
| completionHandler | The completion handler to execute when the request completes or errors |

### `==(_:_:)`

```swift
public static func ==(lhs: HTTPNetworkTransport, rhs: HTTPNetworkTransport) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | A value to compare. |
| rhs | Another value to compare. |