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

func postPasswordRecovery(c *gin.Context) {
	var body struct {
		ReceiverName  string `json:"receiverName" binding:"required"`
		ReceiverEmail string `json:"receiverEmail" binding:"required"`
		Token         string `json:"token" binding:"required"`
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusInternalServerError, formatError(c, err))
		return
	}

	if err := api.SendPasswordRecoveryEmail(
		body.ReceiverName,
		body.ReceiverEmail,
		body.Token,
	); err != nil {
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
	var body struct {
		ReceiverName  string `json:"receiverName" binding:"required"`
		ReceiverEmail string `json:"receiverEmail" binding:"required"`
		VideoID       string `json:"videoId" binding:"required"`
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusInternalServerError, formatError(c, err))
		return
	}

	if err := api.SendEncodingFinishedEmail(
		body.ReceiverName,
		body.ReceiverEmail,
		body.VideoID,
	); err != nil {
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
	if err.Error() == "Key: '.ReceiverName' Error:Field validation for 'ReceiverName' failed on the 'required' tag" {
		return map[string]interface{}{
			"message": "Malformed body",
			"data": map[string]string{
				"ReceiverName": "can't be empty",
			},
		}
	} else if err.Error() == "Key: '.ReceiverEmail' Error:Field validation for 'ReceiverEmail' failed on the 'required' tag" {
		return map[string]interface{}{
			"message": "Malformed body",
			"data": map[string]string{
				"ReceiverEmail": "can't be empty",
			},
		}
	} else if err.Error() == "Key: '.Token' Error:Field validation for 'Token' failed on the 'required' tag" {
		return map[string]interface{}{
			"message": "Malformed body",
			"data": map[string]string{
				"token": "can't be empty",
			},
		}
	} else if err.Error() == "Key: '.VideoID' Error:Field validation for 'VideoID' failed on the 'required' tag" {
		return map[string]interface{}{
			"message": "Malformed body",
			"data": map[string]string{
				"videoID": "can't be empty",
			},
		}
	}
	return map[string]interface{}{
		"message": "Malformed body",
		"data":    map[string]string{},
	}
}
