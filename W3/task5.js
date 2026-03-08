db.content.createIndex({ title: 1 });

db.content.createIndex({ genre: 1 });

db.content.getIndexes();

// title: busquedas frecuentes
// genre: uso de filtros

db.ratings.aggregate([
  {
    $group: {
      _id: "$contentId",
      averageRating: { $avg: "$rating" },
      totalRatings: { $sum: 1 }
    }
  },
  {
    $sort: { averageRating: -1 }
  }
]);

db.content.aggregate([
  { $unwind: "$genre" },
  {
    $group: {
      _id: "$genre",
      total: { $sum: 1 }
    }
  },
  { $sort: { total: -1 } }
]);