# Petit (flutter)

```
$ dart pub global activate melos
$ dart pub global activate rps
$ melos bootstrap
```

## Notes

``` dart
return Rx.combineLatest2(
  database.accountStream(),
  database.connectionsStream(),
  (Account account, List<Connections> connections) {
    connections.forEach((connection) {
      account.connections.add(connection.documentId);
    });
    return account;
  },
);
```