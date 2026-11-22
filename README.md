# Chap10

Node.js/Express.js + TypeScript + Prisma ja PostgreSQL.

## 1) Docker

Varmista, että Docker Desktop on käynnissä ennen tietokantakomentoja.

## 2) Asennus tyhjästä

Aja projektin juuressa:

```powershell
npm ci
```

## 3) PostgreSQL Docker Desktopilla

Luo tarvittaessa Postgres-kontti:

```powershell
docker run --name chap10-postgres -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -e POSTGRES_DB=chap10db -p 5434:5432 -d postgres:16
```

Jos kontti on jo luotu aiemmin mutta pysäytetty, käynnistä se:

```powershell
docker start chap10-postgres
```

Varmista, että yhteys toimii:

```powershell
docker ps
```

Jos haluat poistaa kontin kokonaan ja aloittaa puhtaalta pöydältä:

```powershell
docker rm -f chap10-postgres
```

## 4) Ympäristömuuttujat

Luo projektin juureen tiedosto `.env` (sitä ei versioida, koska se on `.gitignore`-listalla).

Voit luoda sen esimerkiksi PowerShellissa:

```powershell
Set-Content .env 'DATABASE_URL="postgresql://myuser:mypassword@localhost:5434/chap10db?schema=public"'
```

`.env.test` on projektissa valmiina integraatiotesteja varten.

Varmista, että arvot osoittavat Docker-konttiin (portti 5434):

`.env`

```env
DATABASE_URL="postgresql://myuser:mypassword@localhost:5434/chap10db?schema=public"
JWT_ACCESS_SECRET="your-access-secret-at-least-32-characters-long"
JWT_REFRESH_SECRET="your-refresh-secret-at-least-32-characters-different"
```

Käytä eri, pitkää ja turvallista satunnaista arvoa molempiin salaisuuksiin. Älä käytä esimerkkiarvoja tuotannossa.

`.env.test`

```env
DATABASE_URL="postgresql://myuser:mypassword@localhost:5434/chap10db_test?schema=public"
NODE_ENV="test"
JWT_ACCESS_SECRET="test-access-secret-at-least-32-characters"
JWT_REFRESH_SECRET="test-refresh-secret-at-least-32-chars"
```

### Testitietokannan luonti

Sovelluksen Docker-kontissa on PostgreSQL käyttäjänä `myuser`. Luo integraatiotestejä varten erillinen tietokanta:

```powershell
docker exec chap10-postgres psql -U myuser -d postgres -c "CREATE DATABASE chap10db_test;"
```

Jos tietokanta on jo luotu, komento näyttää virheen `database already exists`. Testitietokannan voi tarkistaa komennolla:

```powershell
docker exec chap10-postgres psql -U myuser -d postgres -c "SELECT datname FROM pg_database WHERE datname = 'chap10db_test';"
```

## 5) Prisma: client, migraatiot ja seed

Aja projektin juuressa:

```powershell
npm run db:generate
npm run db:migrate
npm run db:seed
```

Halutessasi voit avata Prisma Studion, suosittelen kokeilemaan:

```powershell
npm run db:studio
```

## 6) Sovelluksen käynnistys

Kehitystilassa:

```powershell
npm run dev
```

## 7) Testien ajo

Unit-testit:

```powershell
npm test
```

Integraatiotestit:

```powershell
npx dotenv -e .env.test -- npx prisma migrate deploy
npm run test:integration
```

Tai suoraan samalla npx-komennolla:

```powershell
npx dotenv -e .env.test -- npx vitest run src/__tests__/integration
```

Huom: Integraatiotestit käyttävät `.env.test`-tiedoston `DATABASE_URL`-arvoa ja tarvitsevat toimivan PostgreSQL-palvelun sekä luodun testitietokannan.

## 8) Build ja tuotantotyyppinen käynnistys

Varmista ensin TypeScript-kääntäminen:

```powershell
npm run build
```

Suorita sitten käännetty sovellus:

```powershell
npm start
```

## 9) Tyypillinen pikakäynnistys

```powershell
npm ci

docker run --name chap10-postgres `
  -e POSTGRES_USER=myuser `
  -e POSTGRES_PASSWORD=mypassword `
  -e POSTGRES_DB=chap10db `
  -p 5434:5432 `
  -d postgres:16

docker exec chap10-postgres psql -U myuser -d postgres `
  -c "CREATE DATABASE chap10db_test;"

npm run db:generate
npm run db:migrate
npm run db:seed

npm test
npx dotenv -e .env.test -- npx prisma migrate deploy
npm run test:integration
npm run build

npm run dev
```
