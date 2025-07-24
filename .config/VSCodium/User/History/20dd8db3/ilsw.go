package controller

import (
	"github.com/gofiber/fiber/v2"
	"gitlab.com/Mawarii/sheethappens/database"
	"gitlab.com/Mawarii/sheethappens/model"
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
	body := new(ReqSkill)
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

	var skill model.Skill

	result := database.DB().Model(model.Skill{}).First(&skill, id)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error,
		})
	}

	skill.Name = body.Name
	skill.Description = body.Description

	database.DB().Save(&skill)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"skill": skill,
	})
}

func DeleteSkill(c *fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "id is required",
		})
	}

	result := database.DB().Unscoped().Delete(&model.Skill{}, id)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to delete skill",
			"error":   result.Error,
		})
	}

	if result.RowsAffected == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "Skill already deleted",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Skill deleted successfully",
	})
}

// Skill Categories

func GetSkillCategories(c *fiber.Ctx) error {
	var categories []model.SkillCategory

	result := database.DB().Model(model.SkillCategory{}).Find(&categories)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error,
		})
	}

	return c.Status(fiber.StatusOK).JSON(categories)
}

func GetSkillCategoryById(c *fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "id is required",
		})
	}

	var category model.SkillCategory

	result := database.DB().Model(model.SkillCategory{}).First(&category, id)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error,
		})
	}

	return c.Status(fiber.StatusOK).JSON(category)
}

type ReqSkillCategory struct {
	Name        string `json:"name"                  bson:"name"`
	Description string `json:"description,omitempty" bson:"description,omitempty"`
}

func CreateSkillCategory(c *fiber.Ctx) error {
	body := new(ReqSkill)
	if err := c.BodyParser(body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	var category model.Skill
	category.Name = body.Name
	category.Description = body.Description

	result := database.DB().Create(&category)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to create skill category",
			"error":   result.Error,
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"category": category,
	})
}

func UpdateSkillCategory(c *fiber.Ctx) error {
	body := new(ReqSkill)
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

	var category model.SkillCategory

	result := database.DB().Model(model.SkillCategory{}).First(&category, id)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error,
		})
	}

	category.Name = body.Name
	category.Description = body.Description

	database.DB().Save(&category)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"category": category,
	})
}

func DeleteSkillCategory(c *fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "id is required",
		})
	}

	result := database.DB().Unscoped().Delete(&model.SkillCategory{}, id)
	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to delete skill category",
			"error":   result.Error,
		})
	}

	if result.RowsAffected == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "Skill category already deleted",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Skill category deleted successfully",
	})
}
