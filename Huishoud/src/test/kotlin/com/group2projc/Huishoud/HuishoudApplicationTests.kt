package com.group2projc.Huishoud

import junit.framework.TestCase.*
import org.junit.Test
import org.junit.runner.RunWith
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.junit4.SpringRunner

@RunWith(SpringRunner::class)
@SpringBootTest
class HuishoudApplicationTests {

	@Test
	fun contextLoads() {
	}

	@Test
	fun test1() {
		assertEquals("Hello, I am the output",HuishoudApplication.doSomeThing())
	}

}
