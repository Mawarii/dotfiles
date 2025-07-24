## Add new application

1. Dist Repo erstellen (naming convention beachten)
2. Apps Repo erstellen (naming convention beachten)
3. `argocd-efa` Deploy Key aktivieren für beide Repos
4. "Project Deployment" Ticket beim DevOps Service Desk erstellen
    - Repo-Link = Applications Repo
    - Where can we find the documentation? = Distributions Repo
    - Summary = Applikationsname + Stage (develop, pre-stage, staging)

Problem: Dist und Apps Repo gibts noch gar nicht, weil wir das ja erstellen müssen...

Neue Idee: Sie erstellen direkt ein Ticket und wir erstellen die Repos und dann geben wir nur Zugriff. Damit liegt die Kontrolle des Namen und auch das der Deploy key gesetzt wird etc. bei uns, weil wir geben ja eh nur auf Repo bzw. Subgroup des Repos Zugriffsrechte.
