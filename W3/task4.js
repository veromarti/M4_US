db.content.updateOne(
  { title: "Inception" },
  { $set: { averageRating: 4.8 } }
);

db.users.updateMany(
  { country: "Colombia" },
  { $set: { subscriptionType: "Premium" } }
);

db.ratings.deleteOne({ rating: 1 });

db.content.deleteMany({
  releaseYear: { $lt: 2000 }
});