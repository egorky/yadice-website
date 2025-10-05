module.exports = {
  apps: [
    {
      name: 'yadice-virtual-agent',
      script: 'npm',
      args: 'run start',
      // Further options for production environment
      // For example, to set environment variables:
      // env: {
      //   NODE_ENV: 'production',
      //   PORT: 3000
      // }
    },
  ],
};