package com.group2projc.Huishoud.database

import com.group2projc.Huishoud.database.DatabaseHelper.BeerTallies.authorid
import com.group2projc.Huishoud.database.DatabaseHelper.BeerTallies.date
import com.group2projc.Huishoud.database.DatabaseHelper.BeerTallies.groupid
import com.group2projc.Huishoud.database.DatabaseHelper.BeerTallies.mutation
import com.group2projc.Huishoud.database.DatabaseHelper.BeerTallies.product
import com.group2projc.Huishoud.database.DatabaseHelper.BeerTallies.targetuserid
import com.group2projc.Huishoud.database.DatabaseHelper.InviteCodes.code
import com.group2projc.Huishoud.database.DatabaseHelper.Users.displayname
import com.group2projc.Huishoud.database.DatabaseHelper.Users.id
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.Random

class DatabaseHelper(url: String) {
    //Singleton pattern for Database connection, Multiple connect calls will cause memory leaks.
    val db by lazy {
        Database.connect(url,
                driver = "org.postgresql.Driver",
                user = "postgres",
                password = "admin")

    }
    //Table definitions

    object Groups : Table() {
        val id = integer("groupid").primaryKey().autoIncrement()
        val created_at = varchar("created_at", 20)
        val name = varchar("name", 50)
    }

    //SQL : CREATE TABLE IF NOT EXISTS users (COLUMNS)
    object Users : Table() {
        val id = varchar("userid", 50).primaryKey()
        val groupid = reference("groupid", Groups.id).nullable()
        val global_permissions = varchar("global_permissions", 10)
        val displayname = varchar("displayname", 20)
        val picturelink = varchar("picturelink", 50)
    }

    object GroupPermissions : Table() {
        val groupid = reference("groupid", Groups.id).primaryKey()
        val userid = reference("userid", Users.id).primaryKey()
        val permission = varchar("permission", 10)
    }

    object Schedules : Table() {
        val taskid = integer("taskid").primaryKey().autoIncrement()
        val groupid = reference("groupid", Groups.id)
        val userid = reference("userid", Users.id)
        val taskname = varchar("taskname", 25)
        val description = varchar("description", 50)
        val datedue = varchar("datedue", 20)
        val done = integer("done")
        val approvals = integer("approvals")
        val ended = integer("ended")
    }

    object BeerTallies : Table() {
        val groupid = reference("groupid", Groups.id).primaryKey()
        val authorid = reference("authorid", Users.id).primaryKey()
        val date = varchar("date", 25).primaryKey()
        val targetuserid = reference("targetid", Users.id)
        val mutation = integer("mutation")
        val product = varchar("product", 50)

    }

    object InviteCodes : Table() {
        val id = integer("id").primaryKey().autoIncrement()
        val groupid = reference("groupid", Groups.id);
        val code = integer("code");
    }

    object Products : Table() {
        val groupid = reference("groupid", Groups.id).primaryKey()
        val name = varchar("name", 50).primaryKey()
        val price = double("price")
    }


//TODO: Find out if it's Possible to use DAO, find way to pass EntityID to postgres

//    //Entity (Row) objects for main tables.
//    // Support for Entities on tables with multiple primary keys is not supported yet :/
//    class Group(id:EntityID<Int>) : IntEntity(id){
//        companion object : IntEntityClass<Group>(Groups)
//        var createdAt by Groups.created_at
//        var name by Groups.name
//        var permissions by User via GroupPermissions
//
//    }
//
//    class User(id:EntityID<String>) : Entity<String>(id){
//        companion object : EntityClass<String, User>(Users)
//        var groupid by Group optionalReferencedOn Users.groupid
//        var globalPermissions by Users.global_permissions
//        var displayName by Users.displayname
//    }
//
//    class GroupPermission(id:EntityID<Int>) : IntEntity(id){
//        companion object : IntEntityClass<GroupPermission>(GroupPermissions)
//        var groupid by Group referencedOn GroupPermissions.groupid
//        var userid by User referencedOn GroupPermissions.userid
//        var permission by GroupPermissions.permission
//    }
//
//    class Schedule(id:EntityID<Int>) : IntEntity(id){
//        companion object : IntEntityClass<Schedule>(Schedules)
//        var groupid by Group referencedOn Schedules.groupid
//        var useridto by User referencedOn Schedules.useridto
//        var useridby by User referencedOn Schedules.useridby
//        var datedue by Schedules.datedue
//        var description by Schedules.description
//    }
//
//    class BeerTally(id:EntityID<Int>) : IntEntity(id){
//        companion object : IntEntityClass<BeerTally>(BeerTallies)
//        var groupid by Group referencedOn BeerTallies.groupid
//        var userid by User referencedOn BeerTallies.userid
//        var count by BeerTallies.count
//    }


    fun initDataBase(): DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            SchemaUtils.create(Groups, Users, GroupPermissions, Schedules, BeerTallies, InviteCodes, Products)
        }

        return this@DatabaseHelper
    }

//    fun createGroup(n: String, uid: String): DatabaseHelper {
//        transaction(db) {
//            addLogger(StdOutSqlLogger)
//            val group = Groups.insert {
//                it[created_at] = LocalDate.now().toString()
//                it[name] = n
//            }
//            addUserToGroup(uid, group[Groups.id], creator = true)
//        }
//        return this@DatabaseHelper
//    }

    fun registerFireBaseUser(t: String, n: String): DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            val query: Query = Users.select { Users.id eq t }
            if (query.count() == 0) {
                Users.insert {
                    it[id] = t
                    it[groupid] = null
                    it[global_permissions] = "user"
                    it[displayname] = n
                    it[picturelink] = ""
                }
            }

        }
        return this@DatabaseHelper
    }

    fun getUser(uid: String): HashMap<String, Any?> {
        var out = HashMap<String, Any?>()
        transaction(db) {
            Users.select({ Users.id eq uid }).forEach {
                out["uid"] = it[Users.id]
                out["groupid"] = it[Users.groupid]
                out["global_permissions"] = it[Users.global_permissions]
                out["display_name"] = it[Users.displayname]
                out["picture_link"] = it[Users.picturelink]
            }

            GroupPermissions.select({ GroupPermissions.userid eq uid }).forEach {
                out["group_permissions"] = it[GroupPermissions.permission]
            }
        }
        return out
    }

    fun userUpdateDisplayName(uid: String, displayname1: String): DatabaseHelper {
        transaction(db) {
            Users.update({ Users.id eq uid }) {
                it[displayname] = displayname1
            }
        }
        return this@DatabaseHelper
    }

    fun userUpdatePicture(uid: String, picturePath: String): DatabaseHelper {
        transaction(db) {
            Users.update({ Users.id eq uid }) {
                it[picturelink] = picturePath
            }
        }
        return this@DatabaseHelper
    }


    fun getGroupName(gid: Int): HashMap<String, Any?> {
        var out = HashMap<String, Any?>()
        transaction(db) {
            Groups.select({ Groups.id eq gid }).forEach {
                out["groupid"] = it[Groups.id]
                out["created_at"] = it[Groups.created_at]
                out["name"] = it[Groups.name]
            }
        }
        return out
    }

    fun setGroupName(gid: Int, newName: String): HashMap<String, Any?> {
        var out = HashMap<String, Any?>()
        out["Succes"] = 0;
        transaction(db) {
            Groups.update({ Groups.id eq gid }) {
                it[Groups.name] = newName
                out["Succes"] = 1
            }

        }
        return out;
    }

    fun addUserToGroup(uid: String, gid: Int, makeUserAdmin: Boolean = false): DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            var group = 0
            Groups.select { Groups.id eq gid }.forEach {
                group = it[Groups.id]
            }
            Users.update({ Users.id eq uid }) {
                it[groupid] = group
            }

            var p = "user"
            if (makeUserAdmin)
                p = "groupAdmin"

            //getAllProducts(gid).foreach((k, v) => productsList.add(v["name"]))
            var productsMap:HashMap<String, HashMap<String, Any>> = getAllProducts(gid);
            productsMap.forEach { k,v ->
                val name:String = v["name"] as String
                val entry = DatabaseHelper.BeerTallies.insert {
                    it[groupid] = gid
                    it[authorid] = uid
                    it[date] = LocalDateTime.now()
                            .minusDays(1)
                            .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"))
                            .toString()
                    it[targetuserid] = uid
                    it[BeerTallies.product] = name
                    it[BeerTallies.mutation] = 0
                }
            }



            setGroupPermission(gid, uid, p)

        }
        return this@DatabaseHelper
    }

    fun setGroupPermission(gid: Int, uid: String, p: String): DatabaseHelper {
        transaction(db) {
            var gpg = 0
            var gpu = ""
            //Find if There is an entry for a permission for this user in this group

            GroupPermissions.select { (GroupPermissions.groupid eq gid) and (GroupPermissions.userid eq uid) }.forEach {
                gpg = it[GroupPermissions.groupid]
                gpu = it[GroupPermissions.userid]
            }
            //If yes, update it
            if (gpg != 0 && gpu != "") {
                GroupPermissions.update({ (GroupPermissions.groupid eq gpg) and (GroupPermissions.userid eq gpu) }) {
                    it[permission] = p
                }
                //If no, create it
            } else {
                GroupPermissions.insert {
                    it[groupid] = gid
                    it[userid] = uid
                    it[permission] = p
                }
            }
        }
        return this@DatabaseHelper
    }

    fun getTallyforGroup(gid: Int, product: String): HashMap<String, Any> {
        val uids = getAllInGroup(gid).values
        var out = HashMap<String, Any>()
        out["product"] = product
        var i = 0
        uids.forEach {
            var singleMap = HashMap<String, Any>();
            singleMap["uid"] = it
            singleMap["count"] = getBeerTally(gid, product, it)
            out["$i"] = singleMap
            i++
        }

        return out;
    }

    fun getNamesAndPicsForGroup(gid: Int): HashMap<String, HashMap<String, String>> {
        val uids = getAllInGroup(gid).values
        var out = HashMap<String, HashMap<String, String>>()
        var i = 0
        uids.forEach {
            var user = HashMap<String, String>()
            user["name"] = getUser(it)["display_name"] as String
            user["picture"] = it
            out["$i"] = user
            i++
        }
        return out
    }

    fun getTallyForGroupByNameAndPic(gid: Int, product: String): HashMap<String, HashMap<String, Any>> {
        val uids = getAllInGroup(gid).values
        print(uids);
        var out = HashMap<String, HashMap<String, Any>>()

        uids.forEach {
            var user = getUser(it)
            var name: String? = user["display_name"] as String?
            var uid: String? = it

            if (name != null && uid != null) {
                var data = HashMap<String, Any>()
                data["picture"] = uid
                data["count"] = getBeerTally(gid, product, it)
                out[name] = data
            }
        }

        return out;
    }

    fun createBeerEntry(gid: Int, authoruid: String, targetuid: String, mutation: Int, product: String): DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            val entry = DatabaseHelper.BeerTallies.insert {
                it[groupid] = gid
                it[authorid] = authoruid
                it[date] = LocalDateTime.now()
                        .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"))
                        .toString()
                it[targetuserid] = targetuid
                it[BeerTallies.product] = product
                it[BeerTallies.mutation] = mutation
            }
        }
        return this@DatabaseHelper
    }

    fun getAllBeerEntriesForGroup(gid: Int): ArrayList<HashMap<String, Any>> {
        var outArr = ArrayList<HashMap<String, Any>>()
        transaction(db) {
            addLogger(StdOutSqlLogger)
            val authorUser = Users.alias("uAuthor")
            val targetUser = Users.alias("uTarget")
            (BeerTallies.innerJoin(authorUser, { authorid }, { authorUser[id] })
                    .innerJoin(targetUser, { targetuserid }, { targetUser[id] }))
                    .select { (BeerTallies.groupid eq gid) }.forEach {
                        var out = HashMap<String, Any>()
                        out["gid"] = gid
                        out["authorid"] = it[authorid]
                        out["authorname"] = it[authorUser[displayname]]
                        out["targetid"] = it[targetuserid]
                        out["targetname"] = it[targetUser[displayname]]
                        out["product"] = it[product]
                        out["mutation"] = it[mutation]
                        out["date"] = it[date]
                        outArr.add(out)
                    }
        }
        return outArr
    }

    fun updateBeerEntry(gid: Int, author: String, target: String, date: String, mut: Int, prod: String): DatabaseHelper {
        transaction(db) {
            BeerTallies.update({ (groupid eq gid) and (authorid eq author) and (targetuserid eq target) and (BeerTallies.date eq date) and (product eq prod) }) {
                it[mutation] = mut
            }
        }
        return this@DatabaseHelper
    }

    fun getBeerTally(gid: Int, product: String, targetuid: String): Int {
        var count = 0
        transaction(db) {
            addLogger(StdOutSqlLogger)
            BeerTallies
                    .slice(mutation)
                    .select { (targetuserid eq targetuid) and (BeerTallies.product eq product) }
                    .forEach {
                        val c = it[mutation]
                        if (c != null) {
                            count += c
                        }
                    }
        }
        return count
    }

    fun getBeerTallyPerUserPerDay(gid: Int, targetuid: String): HashMap<Int, HashMap<String, Int>> {
        var out = HashMap<Int, HashMap<String, Int>>()
        var i = 0
        var count = 0
        transaction(db) {
            BeerTallies
                    .slice(mutation.sum(), date.substring(0, 11))
                    .select { (targetuserid eq targetuid) }
                    .groupBy(date.substring(0, 11))
                    .orderBy(date.substring(0, 11))
                    .forEach {
                        var day = it[date.substring(0, 11)]
                        val c = it[mutation.sum()]
                        if (c != null) {
                            count += c
                        }
                        var placeholder = HashMap<String, Int>()
                        placeholder[day] = count
                        i += 1
                        out[i] = placeholder
                    }
        }
        return out
    } // todo make it perday (groupby maybe?) todo: give days with 0 count still data...

    fun getAllUsersFromGroup(gid: Int) {

    }

    fun getAllInGroup(gid: Int): HashMap<String, String> {
        var out = HashMap<String, String>()
        transaction(db) {
            var i = 0
            Users.select { (Users.groupid eq gid) }.forEach {
                out["UserId${i}"] = it[Users.id]
                i++
            }
        }
        return out
    }


    fun getUserInfoInGroup(gid: Int): ArrayList<HashMap<String, String>> {
        var out = ArrayList<HashMap<String, String>>()

        transaction(db) {
            Users.select { (Users.groupid eq gid) }.forEach {
                var user = HashMap<String, String>()
                user["uid"] = it[Users.id]
                user["displayname"] = it[Users.displayname]
                user["picturelink"] = it[Users.picturelink]

                out.add(user)

            }
        }
        return out
    }

    fun getUserTasks(uid: String): ArrayList<HashMap<String, Any>> {
        var out = ArrayList<HashMap<String, Any>>()

        transaction(db) {
            Schedules.select { (Schedules.userid eq uid) }.forEach {
                if (it[Schedules.ended] == 0) {
                    var task = HashMap<String, Any>()
                    task["taskid"] = it[Schedules.taskid]
                    task["taskname"] = it[Schedules.taskname]
                    task["description"] = it[Schedules.description]
                    task["datedue"] = it[Schedules.datedue]
                    task["done"] = it[Schedules.done]
                    task["approvals"] = it[Schedules.approvals]
                    task["ended"] = it[Schedules.ended]

                    out.add(task)
                }
            }
        }
        return out
    }

    fun getTotalConsumePerMonthPerUser(gid: Int): HashMap<String, Int> {
        val uids = getAllInGroup(gid).values
        var month = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"))
                .toString().substring(5, 7)
        var out = HashMap<String, Int>()
        uids.forEach { id ->
            var user = getUser(id)
            var name: String? = user["display_name"] as String?
            transaction(db) {
                BeerTallies
                        .slice(mutation.sum(), date.substring(6, 2))
                        .select { targetuserid eq id }
                        .groupBy(date.substring(6, 2))
                        .orderBy(date.substring(6, 2))
                        .forEach { i ->
                            if (i[date.substring(6, 2)] == month && i[mutation.sum()] != null) {
                                val total = i[mutation.sum()]
                                if (total != null && name != null) {
                                    out[name] = total
                                }
                            }
                        }

            }
        }
        return out
    }


    fun getHousematesChecks(gid: Int, uid: String): ArrayList<HashMap<String, Any>> {
        var out = ArrayList<HashMap<String, Any>>()

        transaction(db) {
            addLogger(StdOutSqlLogger)
            (Schedules innerJoin Users).select { (Schedules.groupid eq gid) and (Schedules.done eq 1) }.forEach {
                if (it[Users.id] != uid && it[Schedules.ended] == 0) {
                    var task = HashMap<String, Any>()
                    task["taskid"] = it[Schedules.taskid]
                    task["uid"] = it[Users.id]
                    task["displayname"] = it[Users.displayname]
                    task["picturelink"] = it[Users.picturelink]
                    task["taskname"] = it[Schedules.taskname]
                    task["description"] = it[Schedules.description]
                    task["datedue"] = it[Schedules.datedue]
                    task["done"] = it[Schedules.done]
                    task["approvals"] = it[Schedules.approvals]
                    task["ended"] = it[Schedules.ended]

                    out.add(task)
                }
            }
        }
        return out
    }

    fun makeTaskDone(tid: Int): DatabaseHelper {
        transaction(db) {
            Schedules.update({ (Schedules.taskid eq tid) }) {
                it[done] = 1
            }
        }
        return this@DatabaseHelper
    }

    fun endTask(tid: Int): DatabaseHelper {
        transaction(db) {
            Schedules.update({ (Schedules.taskid eq tid) }) {
                it[ended] = 1
            }
        }
        return this@DatabaseHelper
    }

    fun approveTask(tid: Int): DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            var value = 0
            Schedules.select { Schedules.taskid eq tid }.forEach {
                value = it[Schedules.approvals]
            }
            Schedules.update({ Schedules.taskid eq tid }) {
                it[approvals] = (value + 1)
            }
        }
        return this@DatabaseHelper
    }

    fun makeSchedule(gid: Int, uid: String, taskName: String, taskDescription: String, dateDue: String): DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)

            Schedules.insert {
                it[groupid] = gid
                it[userid] = uid
                it[taskname] = taskName
                it[description] = taskDescription
                it[datedue] = dateDue
                it[done] = 0
                it[approvals] = 0
                it[ended] = 0
            }
        }
        return this@DatabaseHelper
    }


    fun createInviteCode(): Int {

        var random = Random();
        var key = random.nextInt(999999 - 100000) + 100000
        return key;


    }

    fun getInviteCode(gid: Int): HashMap<String, Int> {
        var keyFound = false;
        var finalKey = 0;
        var out = HashMap<String, Int>();
        while (!keyFound) {
            var key = createInviteCode();
            var alreadyInUse = false;
            transaction(db) {
                DatabaseHelper.InviteCodes.select { (DatabaseHelper.InviteCodes.code eq key) }.forEach {
                    alreadyInUse = true;
                }
            }
            if (!alreadyInUse) {
                keyFound = true
                finalKey = key;
                out["code"] = finalKey;
            }
        }

        transaction(db) {
            DatabaseHelper.InviteCodes.insert {
                it[groupid] = gid;
                it[code] = finalKey;
            }
        }
        return out;
    }

    fun joinGroubByCode(ic: Int, uid: String): HashMap<String, String> {
        var groupid: Int? = null;
        var out = HashMap<String, String>()
        transaction(db) {
            DatabaseHelper.InviteCodes.select { (DatabaseHelper.InviteCodes.code eq ic) }.forEach {
                groupid = it[DatabaseHelper.InviteCodes.groupid];
            }
        }
        if (groupid != null) {
            transaction(db) {
                DatabaseHelper.InviteCodes.deleteWhere { (DatabaseHelper.InviteCodes.code eq ic) }
            }
            addUserToGroup(uid, groupid!!);
            out["result"] = "Succes";
        } else {
            out["result"] = "Code not found";
        }

        return out;
    }

    fun getAllProducts(gid: Int): HashMap<String, HashMap<String, Any>> {
        var out = HashMap<String, HashMap<String, Any>>()
        transaction(db) {
            var i = 0
            Products.select { (Products.groupid eq gid) }.forEach {
                out["${i}"] = HashMap<String, Any>()
                out["${i}"]?.set("name", it[Products.name])
                out["${i}"]?.set("price", it[Products.price])
                i++
            }
        }
        return out
    }

    fun addProduct(gid: Int, name: String, price: Double): DatabaseHelper {
        transaction(db) {
            Products.insert {
                it[Products.groupid] = gid
                it[Products.name] = name
                it[Products.price] = price
            }
        }

        return this@DatabaseHelper
    }

    fun setGroupPermission(uid: String, admin: Boolean): HashMap<String, String> {
        var out = HashMap<String, String>()
        out["result"] = "failed"
        transaction(db) {
            GroupPermissions.update({ GroupPermissions.userid eq uid }) {
                if (admin) {
                    it[permission] = "groupAdmin"
                } else {
                    it[permission] = "user"
                }
                out["result"] = "success"

            }
        }
        return out;
    }

    fun deleteUserFromGroup(uid: String): HashMap<String, String> {
        var out = HashMap<String, String>()
        out["result"] = "failed"
        transaction(db) {
            BeerTallies.deleteWhere { BeerTallies.targetuserid eq uid }
            Schedules.deleteWhere { Schedules.userid eq uid }
            GroupPermissions.deleteWhere { GroupPermissions.userid eq uid }
            Users.update({ Users.id eq uid }) {
                it[Users.groupid] = null
            }
            out["result"] = "success"
        }
        return out;


    }
}

fun DatabaseHelper.createGroup(n: String, uid: String): DatabaseHelper {
    transaction(db) {
        addLogger(StdOutSqlLogger)
        val group = DatabaseHelper.Groups.insert {
            it[created_at] = LocalDate.now().toString()
            it[name] = n
        }
        addUserToGroup(uid, group[DatabaseHelper.Groups.id], makeUserAdmin = true)
        addProduct(group[DatabaseHelper.Groups.id], "bier", 1.0)
    }
    return this
}