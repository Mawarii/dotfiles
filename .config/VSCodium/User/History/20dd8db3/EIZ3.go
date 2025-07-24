package controller

import (
	"github.com/gofiber/fiber/v2"
	"gitlab.com/Mawarii/sheethappens/database"
	"gitlab.com/Mawarii/sheethappens/model"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func GetSkills(c *fiber.Ctx) error {
	var skills []model.Skill

	result := database.DB().Model(model.Skill{}).Find(&skills)

	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error,
		})
	}

	return c.Status(fiber.StatusOK).JSON(skills)
}

func GetSkillById(c *fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "id is required",
		})
	}

	var skill model.Skill

	result := database.DB().Model(model.Skill{}).First(&skill, id)

	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error,
		})
	}

	return c.Status(fiber.StatusOK).JSON(skill)
}

type ReqSkill struct {
	Name        string `json:"name"                  bson:"name"`
	Description string `json:"description,omitempty" bson:"description,omitempty"`
}

func CreateSkill(c *fiber.Ctx) error {
	body := new(ReqSkill)
	if err := c.BodyParser(body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	var skill model.Skill
	skill.Name = body.Name
	skill.Description = body.Description

	result := database.DB().Create(&skill)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to create skill",
			"error":   result.Error,
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"skill": skill,
	})
}

func UpdateSkill(c *fiber.Ctx) error {
	b := new(ReqSkill)
	if err := c.BodyParser(b); err != nil {
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

	skillObjectID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	coll := database.GetCollection("skills")
	result, err := coll.UpdateOne(c.Context(), bson.D{{Key: "_id", Value: skillObjectID}}, bson.D{{Key: "$set", Value: b}})
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "failed to updated skill",
			"error":   err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"result": result,
	})
}

func DeleteSkill(c *fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "id is required",
		})
	}

	skillObjectID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	coll := database.GetCollection("skills")
	result, err := coll.DeleteOne(c.Context(), bson.D{{Key: "_id", Value: skillObjectID}})
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "failed to delete skill",
			"error":   err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"result": result,
	})
}
