package main

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"gitlab.com/Mawarii/sheethappens/controller"
	"gitlab.com/Mawarii/sheethappens/database"
	"gitlab.com/Mawarii/sheethappens/middleware"
	"gitlab.com/Mawarii/sheethappens/utils"
)

func main() {
	utils.LoadEnv()
	database.Init()

	app := fiber.New()

	app.Use(logger.New())
	app.Use(recover.New())
	app.Use(cors.New(cors.Config{
		AllowOrigins:     "http://localhost:8080",
		AllowMethods:     "GET,POST,PUT,DELETE",
		AllowHeaders:     "Content-Type",
		AllowCredentials: true,
	}))

	api := app.Group("/api")

	auth := api.Group("/auth")
	auth.Post("/register", controller.Register)
	auth.Post("/login", controller.Login)
	auth.Get("/logout", controller.Logout)
	auth.Get("/info", middleware.JWTProtected, controller.GetUserInfo)

	characters := api.Group("/characters", middleware.JWTProtected)
	characters.Get("/", controller.GetCharacters)
	characters.Get("/:id", controller.GetCharacterById)
	characters.Post("/", controller.CreateCharacter)
	characters.Put("/:id", controller.UpdateCharacter)
	characters.Delete("/:id", controller.DeleteCharacter)

	skills := api.Group("/skills")
	skills.Get("/", controller.GetSkills)
	skills.Get("/:id", controller.GetSkillById)
	skills.Post("/", middleware.JWTProtected, controller.CreateSkill)
	skills.Put("/:id", middleware.JWTProtected, controller.UpdateSkill)
	skills.Delete("/:id", middleware.JWTProtected, controller.DeleteSkill)
	skills.Get("/categories", controller.GetSkillCategories)
	skills.Get("/categories/:id", controller.GetSkillCategoryById)
	skills.Post("/categories", middleware.JWTProtected, controller.CreateSkillCategory)
	skills.Put("/categories/:id", middleware.JWTProtected, controller.UpdateSkillCategory)
	skills.Delete("/categories/:id", middleware.JWTProtected, controller.DeleteSkillCategory)

	app.Listen(":3000")
}
