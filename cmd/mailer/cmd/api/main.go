package main

import (
	"net/http"

	"github.com/ImNotAVirus/YouTube.ex/cmd/mailer/internal/app/api"

	"github.com/gin-gonic/gin"
)

var port = api.GetPort()

func main() {
	r := gin.Default()

	v1 := r.Group("/api/v1")
	{
		email := v1.Group("/email")
		{
			email.POST("/password-recovery", postPasswordRecovery)
			email.POST("/encoding-finished", postEncodingFinished)
		}
	}

	r.Run(":" + port)
}

type emailRequest struct {
	ToName  string `json:"toName" binding:"required"`
	ToEmail string `json:"toEmail" binding:"required"`
}

func postPasswordRecovery(c *gin.Context) {
	var body emailRequest

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusInternalServerError, formatError(c, err))
		return
	}

	if err := api.SendPasswordRecoveryEmail(body.ToName, body.ToEmail); err != nil {
		c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"message": "Fail to send email",
			"data":    map[string]string{},
		})
		return
	}

	c.JSON(http.StatusAccepted, map[string]interface{}{
		"message": "OK",
		"data":    map[string]string{},
	})
}

func postEncodingFinished(c *gin.Context) {
	var body emailRequest

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusInternalServerError, formatError(c, err))
		return
	}

	if err := api.SendEncodingFinishedEmail(body.ToName, body.ToEmail); err != nil {
		c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"message": "Fail to send email",
			"data":    map[string]string{},
		})
		return
	}

	c.JSON(http.StatusAccepted, map[string]interface{}{
		"message": "OK",
		"data":    map[string]string{},
	})
}

func formatError(c *gin.Context, err error) map[string]interface{} {
	if err.Error() == "Key: '.ToName' Error:Field validation for 'ToName' failed on the 'required' tag" {
		return map[string]interface{}{
			"message": "Malformed body",
			"data": map[string]string{
				"toName": "can't be empty",
			},
		}
	} else if err.Error() == "Key: '.ToEmail' Error:Field validation for 'ToEmail' failed on the 'required' tag" {
		return map[string]interface{}{
			"message": "Malformed body",
			"data": map[string]string{
				"toEmail": "can't be empty",
			},
		}
	}
	return map[string]interface{}{
		"message": "Malformed body",
		"data":    map[string]string{},
	}
}
