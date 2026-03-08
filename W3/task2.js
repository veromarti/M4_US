db.content.insertMany([
  {
    title: "Inception",
    type: "movie",
    genre: ["Sci-Fi", "Thriller"],
    duration: 148,
    releaseYear: 2010,
    averageRating: 4.5
  },
  {
    title: "The Irishman",
    type: "movie",
    genre: ["Crime", "Drama"],
    duration: 209,
    releaseYear: 2019,
    averageRating: 4.2
  },
  {
    title: "Dark",
    type: "series",
    genre: ["Sci-Fi", "Drama"],
    seasons: 3,
    episodes: 26,
    averageRating: 4.7
  }
]);

db.users.insertMany([
  {
    name: "Veronica",
    email: "vero@mail.com",
    age: 26,
    country: "Colombia",
    subscriptionType: "Premium",
    watchHistory: []
  },
  {
    name: "Juan",
    email: "juan@mail.com",
    age: 30,
    country: "Mexico",
    subscriptionType: "Basic",
    watchHistory: []
  }
]);