class Helper {
  static getProductsData(Map<String, dynamic> data) {
    return data['products'] ?? [];
  }
  static getProductData(Map<String, dynamic> data) {
    return data['product'] ?? [];
  }
  static getRelatedProductData(Map<String, dynamic> data) {
    return data['related_products'] ?? [];
    // return data['product'] ?? [];
  }
  static getCategoryProductData(Map<String, dynamic> data) {
    return data['category']['products'] ?? [];
  }
  static getChildCategoryProductData(Map<String, dynamic> data) {
    return data['child_category']['products'] ?? [];
  }
  static getSubCategoryProductData(Map<String, dynamic> data) {
    return data['sub_category']['products'] ?? [];
  }
  static getFavoritesData(Map<String, dynamic> data) {
    return data['favourites']['favourites'] ?? [];
  }

  static getCategoriesData(Map<String, dynamic> data) {
    return data['categories'] ?? [];
  }

  static getSubCategoriesData(Map<String, dynamic> data) {
    return data['subcategories'] ?? [];
  }
  static getChildCategoriesData(Map<String, dynamic> data) {
    return data['childcategories'] ?? [];
  }

  static getUserData(Map<String, dynamic> data) {
    return data['user'] ?? [];
  }

  static getBannersData(Map<String, dynamic> data) {
    return data['banner'] ?? [];
  }

  static getChildCategoryAttributeData(Map<String, dynamic> data) {
    return data['child_category']['attributes'] ?? [];
  }

  static getBidsData(Map<String, dynamic> data) {
    return data['bids'] ?? [];
  }

  static getWishlistData(Map<String, dynamic> data) {
    return data['wishlist']['wishlists'] ?? [];
  }

  static getReviewsData(Map<String, dynamic> data) {
    return data['productReviews']['reviews'] ?? [];
  }

  static getQuestionData(Map<String, dynamic> data) {
    return data['question'] ?? [];
  }

}