const { PrismaClient, Prisma } = require('@prisma/client');
const { PrismaPg} = require('@prisma/adapter-pg');
const readline = require('readline');
const { exit } = require('process');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

const adapter = new PrismaPg({ 
  connectionString: process.env.DATABASE_URL,
  password: "PIequals31415",
  user: "postgres",
  database: "lab6"
});

const prisma = new PrismaClient({ adapter });

const prompt = (text) => {
   return new Promise((resolve, reject) => {
    rl.question(text, (answer) => {
      resolve(answer);
    })
   });
}

const READ = 'r';
const EXIT = 'e';
const CREATE = 'c';

const processCreation = async (modelName) => {
  const dmmf = Prisma.dmmf;
  const models = dmmf.datamodel.models;
  const model = models.find(model => {
    return model.name.toLowerCase() === modelName;
  });
  const dto = {};
  for (const field of model.fields) {
    if (field.kind === 'object' || field.name === 'id') continue;
    const value = await prompt(`Enter ${field.name} value: `);
    dto[field.name] = value;
  }

  return dto;
}

const main = async () => {
  while (true) {
    const action = (await prompt('What you want to do?')).trim();
    
    let breakLoop = false;
    switch (action) {
      case READ:
        const table = (await prompt('enter table that you wanna read:')).trim();
        const entries = await prisma[table].findMany();
        console.table(entries);
        break;
      case CREATE:
          const entry = (await prompt('enter entry that you wanna create:')).trim();
          const dto = await processCreation(entry);
          const manager = prisma[entry];

          await manager.create({data: dto});
          break;
      case EXIT:
        breakLoop = true;
        break;
    }

    if (breakLoop) break;
  }
  throw new Error("end of session");
}


main()
  .catch(e => {
    console.log('END of process...');
  })
  .finally(async () => {
    await prisma.$disconnect();
    exit();
});
