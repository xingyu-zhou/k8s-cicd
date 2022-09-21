
---
What Suppose to happen
---

When source codes are merged/committed to main branch,
workflow of "Release_Deploy" will automatically be triggered.
It will release a new image to ECR and make a new deployment to EKS.

---
 Those need to be finished (Which are not until now)
---
- Put the secrets into the "Secrets" in EKS.
>I think I need to add a secret yaml file or a paragraph 
- Run the application in browser.
>I need an alb
- Run the application to connect with RDS.
>I need to connect the application to DB.
