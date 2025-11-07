const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const bcrypt = require("bcryptjs");

const app = express();
const PORT = 3001;


app.use(cors());
app.use(express.json());


app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
  res.header("Access-Control-Allow-Headers", "Content-Type");
  next();
});


mongoose.connect(
  "mongodb+srv://hasennazerke1_db_user:KIrEn0k0LGe4oBUe@cluster0.xw15it9.mongodb.net/?appName=Cluster0"
)
  .then(() => console.log("✅ MongoDB Atlas connected"))
  .catch(err => console.error("❌ MongoDB connection error:", err));


const userSchema = new mongoose.Schema({
  username: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  age: String,
  gender: String,
  moods: [
    {
      emoji: String,
      mood: String,
      reason: String,
      date: { type: Date, default: Date.now },
    }
  ],
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});


userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (err) {
    next(err);
  }
});

const User = mongoose.model("User", userSchema);




app.post("/register", async (req, res) => {
  try {
    const { username, email, password, age, gender } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser)
      return res.status(400).json({ message: "Такой email уже существует" });

    const newUser = new User({ username, email, password, age, gender });
    await newUser.save();

    
    res.status(201).json({
      message: "Пользователь успешно зарегистрирован!",
      user: {
        username: newUser.username,
        email: newUser.email,
        age: newUser.age,
        gender: newUser.gender,
        createdAt: newUser.createdAt,
        updatedAt: newUser.updatedAt,
      },
    });
  } catch (error) {
    console.error("Ошибка при регистрации:", error);
    res.status(500).json({ message: "Ошибка сервера" });
  }
});


app.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user)
      return res.status(400).json({ message: "Пользователь не найден" });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch)
      return res.status(400).json({ message: "Неверный пароль" });

    res.status(200).json({
      message: "Успешный вход!",
      user: {
        username: user.username,
        email: user.email,
        age: user.age,
        gender: user.gender,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      },
    });
  } catch (error) {
    console.error("Ошибка при входе:", error);
    res.status(500).json({ message: "Ошибка сервера" });
  }
});


app.put("/updateUser", async (req, res) => {
  const { email, username, age, gender } = req.body;

  try {
    const user = await User.findOneAndUpdate(
      { email: email },
      { username, age, gender, updatedAt: new Date() },
      { new: true }
    );

    if (!user)
      return res.status(404).json({ message: "Пользователь не найден" });

    res.json({ message: "Профиль успешно обновлён!", user });
  } catch (err) {
    console.error("Ошибка при обновлении:", err);
    res.status(500).json({ message: "Ошибка обновления профиля" });
  }
});


app.post('/reset-password', async (req, res) => {
  try {
    const { email, username, newPassword } = req.body;
    const bcrypt = require('bcrypt');

    const user = await User.findOne({ email, username });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    user.password = await bcrypt.hash(newPassword, 10);
    await user.save();

    res.status(200).json({ message: 'Password updated successfully' });

  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});


app.post("/check-user", async (req, res) => {
  try {
    const { email, username } = req.body;

    const user = await User.findOne({ email, username });

    if (!user) {
      return res.status(404).json({ message: "Пользователь не найден" });
    }

    res.status(200).json({ message: "OK ✅" });

  } catch (error) {
    console.error("Ошибка /check-user:", error);
    res.status(500).json({ message: "Ошибка сервера" });
  }
});


app.post("/update-password", async (req, res) => {
  try {
    const { email, username, newPassword } = req.body;

    const user = await User.findOne({ email, username });
    if (!user) {
      return res.status(404).json({ message: "Пользователь не найден" });
    }

    user.password = await bcrypt.hash(newPassword, 10);
    user.updatedAt = new Date();
    await user.save();

    res.status(200).json({ message: "Пароль успешно обновлён ✅" });

  } catch (error) {
    console.error("Ошибка /update-password:", error);
    res.status(500).json({ message: "Ошибка сервера" });
  }
});


app.post("/add-mood", async (req, res) => {
  try {
    const { email, mood, emoji, reason } = req.body;

    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ message: "Пользователь не найден" });

    user.moods.push({ mood, emoji, reason, date: new Date() });
    user.updatedAt = new Date();
    await user.save();

    res.status(201).json({ message: "Настроение сохранено ✅", moods: user.moods });
  } catch (err) {
    console.error("Ошибка /add-mood:", err);
    res.status(500).json({ message: "Ошибка сервера" });
  }
});


app.get("/get-moods", async (req, res) => {
  try {
    const { email } = req.query;
    if (!email) return res.status(400).json({ message: "Email обязателен" });

    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ message: "Пользователь не найден" });

    res.status(200).json({ moods: user.moods });
  } catch (err) {
    console.error("Ошибка /get-moods:", err);
    res.status(500).json({ message: "Ошибка сервера" });
  }
});




app.get("/", (req, res) => {
  res.json({ message: "✅ Сервер работает" });
});


app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Сервер запущен: http://192.168.1.67:${PORT}`);
});
