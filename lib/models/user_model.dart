class UserResponse {
  final List<UserModel> results;
  final ApiInfo info;

  UserResponse({
    required this.results,
    required this.info,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      results: (json['results'] as List)
          .map((user) => UserModel.fromJson(user))
          .toList(),
      info: ApiInfo.fromJson(json['info']),
    );
  }
}

class ApiInfo {
  final String seed;
  final int results;
  final int page;
  final String version;

  ApiInfo({
    required this.seed,
    required this.results,
    required this.page,
    required this.version,
  });

  factory ApiInfo.fromJson(Map<String, dynamic> json) {
    return ApiInfo(
      seed: json['seed'],
      results: json['results'],
      page: json['page'],
      version: json['version'],
    );
  }
}

class UserModel {
  final String gender;
  final UserName name;
  final UserLocation location;
  final String email;
  final UserLogin login;
  final UserDob dob;
  final UserRegistered registered;
  final String phone;
  final String cell;
  final UserId id;
  final UserPicture picture;
  final String nat;

  UserModel({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.login,
    required this.dob,
    required this.registered,
    required this.phone,
    required this.cell,
    required this.id,
    required this.picture,
    required this.nat,
  });

  String get fullName => '${name.first} ${name.last}';
  String get displayName => '${name.title} ${name.first} ${name.last}';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      gender: json['gender'],
      name: UserName.fromJson(json['name']),
      location: UserLocation.fromJson(json['location']),
      email: json['email'],
      login: UserLogin.fromJson(json['login']),
      dob: UserDob.fromJson(json['dob']),
      registered: UserRegistered.fromJson(json['registered']),
      phone: json['phone'],
      cell: json['cell'],
      id: UserId.fromJson(json['id']),
      picture: UserPicture.fromJson(json['picture']),
      nat: json['nat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': name.toJson(),
      'location': location.toJson(),
      'email': email,
      'login': login.toJson(),
      'dob': dob.toJson(),
      'registered': registered.toJson(),
      'phone': phone,
      'cell': cell,
      'id': id.toJson(),
      'picture': picture.toJson(),
      'nat': nat,
    };
  }
}

class UserName {
  final String title;
  final String first;
  final String last;

  UserName({
    required this.title,
    required this.first,
    required this.last,
  });

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      title: json['title'],
      first: json['first'],
      last: json['last'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'first': first,
      'last': last,
    };
  }
}

class UserLocation {
  final UserStreet street;
  final String city;
  final String state;
  final String country;
  final dynamic postcode; // Can be int or String
  final UserCoordinates coordinates;
  final UserTimezone timezone;

  UserLocation({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.coordinates,
    required this.timezone,
  });

  String get fullAddress => '${street.number} ${street.name}, $city, $state, $country $postcode';

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      street: UserStreet.fromJson(json['street']),
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postcode: json['postcode'],
      coordinates: UserCoordinates.fromJson(json['coordinates']),
      timezone: UserTimezone.fromJson(json['timezone']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street.toJson(),
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
      'coordinates': coordinates.toJson(),
      'timezone': timezone.toJson(),
    };
  }
}

class UserStreet {
  final int number;
  final String name;

  UserStreet({
    required this.number,
    required this.name,
  });

  factory UserStreet.fromJson(Map<String, dynamic> json) {
    return UserStreet(
      number: json['number'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
    };
  }
}

class UserCoordinates {
  final String latitude;
  final String longitude;

  UserCoordinates({
    required this.latitude,
    required this.longitude,
  });

  factory UserCoordinates.fromJson(Map<String, dynamic> json) {
    return UserCoordinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class UserTimezone {
  final String offset;
  final String description;

  UserTimezone({
    required this.offset,
    required this.description,
  });

  factory UserTimezone.fromJson(Map<String, dynamic> json) {
    return UserTimezone(
      offset: json['offset'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'description': description,
    };
  }
}

class UserLogin {
  final String uuid;
  final String username;
  final String password;
  final String salt;
  final String md5;
  final String sha1;
  final String sha256;

  UserLogin({
    required this.uuid,
    required this.username,
    required this.password,
    required this.salt,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      uuid: json['uuid'],
      username: json['username'],
      password: json['password'],
      salt: json['salt'],
      md5: json['md5'],
      sha1: json['sha1'],
      sha256: json['sha256'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'password': password,
      'salt': salt,
      'md5': md5,
      'sha1': sha1,
      'sha256': sha256,
    };
  }
}

class UserDob {
  final DateTime date;
  final int age;

  UserDob({
    required this.date,
    required this.age,
  });

  factory UserDob.fromJson(Map<String, dynamic> json) {
    return UserDob(
      date: DateTime.parse(json['date']),
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'age': age,
    };
  }
}

class UserRegistered {
  final DateTime date;
  final int age;

  UserRegistered({
    required this.date,
    required this.age,
  });

  factory UserRegistered.fromJson(Map<String, dynamic> json) {
    return UserRegistered(
      date: DateTime.parse(json['date']),
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'age': age,
    };
  }
}

class UserId {
  final String name;
  final String? value;

  UserId({
    required this.name,
    this.value,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      name: json['name'] ?? '',
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class UserPicture {
  final String large;
  final String medium;
  final String thumbnail;

  UserPicture({
    required this.large,
    required this.medium,
    required this.thumbnail,
  });

  factory UserPicture.fromJson(Map<String, dynamic> json) {
    return UserPicture(
      large: json['large'],
      medium: json['medium'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'large': large,
      'medium': medium,
      'thumbnail': thumbnail,
    };
  }
}