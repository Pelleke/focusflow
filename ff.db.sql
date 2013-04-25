/*
 Navicat Premium Data Transfer

 Source Server         : FocusFlow
 Source Server Type    : SQLite
 Source Server Version : 3007011
 Source Database       : main

 Target Server Type    : SQLite
 Target Server Version : 3007011
 File Encoding         : utf-8

 Date: 04/26/2013 00:20:51 AM
*/

PRAGMA foreign_keys = false;

-- ----------------------------
--  Table structure for "task"
-- ----------------------------
DROP TABLE IF EXISTS "task";
CREATE TABLE "task" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"description"  VARCHAR(255) NOT NULL
);

-- ----------------------------
--  Table structure for "tick"
-- ----------------------------
DROP TABLE IF EXISTS "tick";
CREATE TABLE "tick" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"task_id"  INTEGER NOT NULL,
"timestamp"  TIMESTAMP NOT NULL,
"distracted"  INTEGER NOT NULL,
CONSTRAINT "TASK" FOREIGN KEY ("task_id") REFERENCES "task" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

PRAGMA foreign_keys = true;
