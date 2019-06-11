package main

import (
	"fmt"
	"io"

	"github.com/ImNotAVirus/YouTube.ex/apps/mailer/pkg/config"

	"github.com/gin-gonic/gin"
	"gopkg.in/gomail.v2"
)

type sendMailBody struct {
	From    string
	To      string
	Subject string
	Content string
}

func main() {
	r := gin.Default()

	v1 := r.Group("/api/v1")
	{
		v1.POST("/", func(c *gin.Context) {
			var body sendMailBody

			if err := c.ShouldBind(body); err != nil {
				c.JSON(500, map[string]interface{}{
					"message": err.Error(),
					"data":    map[string]interface{}{},
				})
			}

			m := gomail.NewMessage()

			m.SetHeader("From", body.From)
			m.SetHeader("To", body.To)
			m.SetHeader("Subject", body.Subject)
			m.SetBody("text/plain", body.Content)

			s := gomail.SendFunc(func(from string, to []string, msg io.WriterTo) error {
				fmt.Println("From:", from)
				fmt.Println("To:", to)
				return nil
			})

			if err := gomail.Send(s, m); err != nil {
				c.JSON(400, map[string]interface{}{
					"message": "Bad Request",
					"data": map[string]interface{}{
						"to": "is ureachable",
					},
				})
			}

			c.JSON(200, gin.H{
				"message": "pong",
			})
		})
	}

	r.Run(":" + config.GetPort())
}
