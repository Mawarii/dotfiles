package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v5"
	"gitlab.com/Mawarii/sheethappens/database"
	"gitlab.com/Mawarii/sheethappens/model"
)

func GetCharacters(c *fiber.Ctx) error {
	userToken := c.Locals("jwt").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["user_id"].(float64))

	var characters []model.Character

	result := database.DB().Model(model.Character{}).Where("user_id = ?", userID).Find(&characters)

	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error,
		})
	}

	return c.Status(fiber.StatusOK).JSON(characters)
}

func GetCharacterById(c *fiber.Ctx) error {
	userToken := c.Locals("jwt").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["user_id"].(float64))

	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "id is required",
		})
	}

	var character model.Character

	result := database.DB().Model(model.Character{}).Where("user_id = ?", userID).First(&character, id)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error,
		})
	}

	return c.Status(fiber.StatusOK).JSON(character)
}

type ReqCharacter struct {
	Name         string `gorm:"not null;" json:"name"`
	Level        uint   `json:"level,omitempty"`
	Health       int    `json:"health,omitempty"`
	MentalHealth int    `json:"mental_health,omitempty"`
	Mana         uint   `json:"mana,omitempty"`
	Race         string `json:"race,omitempty"`
	Gender       string `json:"gender,omitempty"`
	Height       string `json:"height,omitempty"`
	Weight       string `json:"weight,omitempty"`
	Dodge        uint   `json:"dodge,omitempty"`
}

func CreateCharacter(c *fiber.Ctx) error {
	userToken := c.Locals("jwt").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["user_id"].(float64))

	body := new(ReqCharacter)
	if err := c.BodyParser(body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	var character model.Character
	character.Name = body.Name
	character.Level = body.Level
	character.Health = body.Health
	character.MentalHealth = body.MentalHealth
	character.Mana = body.Mana
	character.Race = body.Race
	character.Gender = body.Gender
	character.Height = body.Height
	character.Weight = body.Weight
	character.Dodge = body.Dodge
	character.UserID = userID

	result := database.DB().Create(&character)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to create character",
			"error":   result.Error,
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"character": character,
	})
}

func UpdateCharacter(c *fiber.Ctx) error {
	userToken := c.Locals("jwt").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["user_id"].(float64))

	body := new(ReqCharacter)
	if err := c.BodyParser(body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "id is required",
		})
	}

	var character model.Character

	result := database.DB().Model(model.Character{}).Where("user_id = ?", userID).First(&character, id)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error,
		})
	}

	character.Name = body.Name
	character.Level = body.Level
	character.Health = body.Health
	character.MentalHealth = body.MentalHealth
	character.Mana = body.Mana
	character.Race = body.Race
	character.Gender = body.Gender
	character.Height = body.Height
	character.Weight = body.Weight
	character.Dodge = body.Dodge

	database.DB().Save(&character)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"character": character,
	})
}

func DeleteCharacter(c *fiber.Ctx) error {
	userToken := c.Locals("jwt").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["user_id"].(float64))

	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "id is required",
		})
	}

	result := database.DB().Unscoped().Where("user_id = ?", userID).Delete(&model.Character{}, id)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to delete character",
			"error":   result.Error,
		})
	}

	if result.RowsAffected == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "Character already deleted",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Character deleted successfully",
	})
}

// func createCharacterSkillCategory(characterID uint, skillID uint, categoryID uint) error {

// 	return nil
// }
