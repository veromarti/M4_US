// movies duración > 120 min
db.content.find({
  duration: { $gt: 120 }
});

// users edad < 28
db.users.find({
  age: { $lt: 28 }
});

// content: movie
db.content.find({
  type: { $eq: "movie" }
});

// genre: Sci-Fi/Drama
db.content.find({
  genre: { $in: ["Sci-Fi", "Drama"] }
});

// and
db.content.find({
  $and: [
    { type: "movie" },
    { duration: { $gt: 150 } }
  ]
});

// or
db.users.find({
  $or: [
    { subscriptionType: "Premium" },
    { country: "Colombia" }
  ]
});