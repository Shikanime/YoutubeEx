package api

import (
	"fmt"
	"log"
	"net/mail"
	"net/smtp"
	"strings"
)

var auth = PlainAuth(
	"",
	GetPostfixUsername(),
	GetPostfixPassword(),
	GetPostfixHost(),
)
var addr = GetPostfixHost() + ":" + GetPostfixPort()

var senderName = "YoutubeEx"
var senderEmail = "noreply@youtube-ex.com"

func SendPasswordRecoveryEmail(toName, toEmail, token string) error {
	subject := "Récupération du mot de passe"
	body := fmt.Sprintf(`Voici ton token de récupération de ton mot de passe: %s.`, token)
	toEmails := []string{toEmail}
	toNames := []string{toName}

	if err := SendMail(toNames, toEmails, subject, body); err != nil {
		return err
	}

	return nil
}

func SendEncodingFinishedEmail(toName, toEmail, videoId string) error {
	subject := "Encodage terminé"
	body := fmt.Sprintf(`La vidéo %s a fini d'être encodée.`, videoId)
	toEmails := []string{toEmail}
	toNames := []string{toName}

	if err := SendMail(toNames, toEmails, subject, body); err != nil {
		return err
	}

	return nil
}

func SendMail(toNames []string, toEmails []string, subject, body string) error {
	msg := ""
	for k, v := range buildHeader(toNames, toEmails, subject) {
		msg += fmt.Sprintf("%s: %s\r\n", k, v)
	}
	msg += "\r\n" + body
	bMsg := []byte(msg)

	// Send using local postfix service
	if err := smtp.SendMail(addr, auth, senderEmail, toEmails, bMsg); err != nil {
		log.Fatal(err.Error())
	}

	return nil
}

func buildHeader(toNames []string, toEmails []string, subject string) map[string]string {
	// Build RFC-2822 email
	toAddresses := []string{}
	for i := range toEmails {
		to := mail.Address{
			Name:    toNames[i],
			Address: toEmails[i],
		}
		toAddresses = append(toAddresses, to.String())
	}

	from := mail.Address{
		Name:    senderName,
		Address: senderEmail,
	}

	return map[string]string{
		"To":           strings.Join(toAddresses, ", "),
		"From":         from.String(),
		"Subject":      subject,
		"Content-Type": `text/html; charset="UTF-8"`,
	}
}
