# Changelog

All notable changes to this project will be documented in this file.

## [1.1.1](https://github.com/OliRafa/sqlite3-local-backups/compare/v1.1.0...v1.1.1) (2024-09-24)


### Bug Fixes

* **entrypoint:** fix script not calling delete-old-backups function ([45952ba](https://github.com/OliRafa/sqlite3-local-backups/commit/45952ba9474e76583c68d4b663bba0cb5703df40))

# [1.1.0](https://github.com/OliRafa/sqlite3-local-backups/compare/v1.0.0...v1.1.0) (2024-09-24)


### Features

* **delete-old-backups:** add backups retention policy enforcement ([6ff35e5](https://github.com/OliRafa/sqlite3-local-backups/commit/6ff35e54104ce8d50f2619a24f6c59f2ce51f9c2))

# 1.0.0 (2024-09-24)


### Bug Fixes

* **create-backup:** fix hard links not being replaced correctly due to a file already existing error ([a4218a2](https://github.com/OliRafa/sqlite3-local-backups/commit/a4218a2699785b0add2f339a84aa43b508c42a8b))


### Features

* add basic functionality to create folder structure for backups retention ([b35a97e](https://github.com/OliRafa/sqlite3-local-backups/commit/b35a97e30f10c1bb280b1b69d4c09a9cf8045215))
* **create-backup:** add basic functionality ([1d8f4c3](https://github.com/OliRafa/sqlite3-local-backups/commit/1d8f4c353dd6798be3531f60f8d190d91c3b53a9))
* **create-backup:** add folder awareness and naive hard links ([a169dd5](https://github.com/OliRafa/sqlite3-local-backups/commit/a169dd58960b932040af7db2d1993bcf881c869d))
* **create-backup:** add generate backup file name with attached datetime ([a2508aa](https://github.com/OliRafa/sqlite3-local-backups/commit/a2508aa8382193e07f19533cb9b3a46ce62495ee))
* **create-backup:** generate soft link for latest dump ([03e835a](https://github.com/OliRafa/sqlite3-local-backups/commit/03e835a6cfd9f0dc93348e63f8acebe63ed7e705))
* **docker:** add base dockerfile ([6c7f972](https://github.com/OliRafa/sqlite3-local-backups/commit/6c7f972f0c5407d6129a0288fdb54a7a204f8e57))
* **docker:** add cron ([383971d](https://github.com/OliRafa/sqlite3-local-backups/commit/383971db2df24cf4f98c02ad12d1b3c3e4dd2f87))
