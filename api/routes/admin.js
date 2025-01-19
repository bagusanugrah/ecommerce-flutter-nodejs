const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");
const Order = require("../models/order");
const User = require("../models/user");
const { PromiseProvider } = require("mongoose");
const cloudinary = require('cloudinary').v2;

cloudinary.config({
  cloud_name: 'drawgchhs',
  api_key: '747137413739323',
  api_secret: 'zxDEMI5ZXIBzl9ibAnj_DYNhYmo',
});

// Add product
adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;
    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
    });
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get all your products
adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get single product by ID
adminRouter.get("/admin/get-product/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);

    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Update product
adminRouter.put("/admin/update-product/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description, images, quantity, price, category, oldImages } = req.body;

    const product = await Product.findById(id);

    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    // Hapus gambar lama jika ada gambar baru
    if (oldImages && oldImages.length > 0 && images.length > 0) {
      for (const oldImage of oldImages) {
        const publicId = oldImage.split('/').pop().split('.')[0]; // Extract public_id
        await cloudinary.uploader.destroy(publicId);
      }
    }

    // Perbarui data produk
    product.name = name || product.name;
    product.description = description || product.description;
    product.images = images.length > 0 ? images : product.images;
    product.quantity = quantity || product.quantity;
    product.price = price || product.price;
    product.category = category || product.category;

    await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// adminRouter.put("/admin/update-product/:id", admin, async (req, res) => {
//   try {
//     const { id } = req.params;
//     const { name, description, images, quantity, price, category } = req.body;

//     const product = await Product.findByIdAndUpdate(
//       id,
//       { name, description, images, quantity, price, category },
//       { new: true, runValidators: true }
//     );

//     if (!product) {
//       return res.status(404).json({ error: "Product not found" });
//     }

//     res.json(product);
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// Delete the product
adminRouter.post("/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;

    // Find and delete the product from the database
    const product = await Product.findByIdAndDelete(id);

    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    // Remove the product from the cart of all users
    const users = await User.find({ "cart.product._id": id });
    for (let user of users) {
      user.cart = user.cart.filter((cartItem) => !cartItem.product.equals(id));
      await user.save();
    }

    res.json({ message: "Product deleted and removed from all carts", product });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;
    let order = await Order.findById(id);
    order.status = status;
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0;

    for (let i = 0; i < orders.length; i++) {
      for (let j = 0; j < orders[i].products.length; j++) {
        totalEarnings +=
          orders[i].products[j].quantity * orders[i].products[j].product.price;
      }
    }
    // CATEGORY WISE ORDER FETCHING
    let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
    let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
    let applianceEarnings = await fetchCategoryWiseProduct("Appliances");
    let booksEarnings = await fetchCategoryWiseProduct("Books");
    let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

    let earnings = {
      totalEarnings,
      mobileEarnings,
      essentialEarnings,
      applianceEarnings,
      booksEarnings,
      fashionEarnings,
    };

    res.json(earnings);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

async function fetchCategoryWiseProduct(category) {
  let earnings = 0;
  let categoryOrders = await Order.find({
    "products.product.category": category,
  });

  for (let i = 0; i < categoryOrders.length; i++) {
    for (let j = 0; j < categoryOrders[i].products.length; j++) {
      earnings +=
        categoryOrders[i].products[j].quantity *
        categoryOrders[i].products[j].product.price;
    }
  }
  return earnings;
}

module.exports = adminRouter;
