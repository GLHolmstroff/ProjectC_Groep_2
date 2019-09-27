package com.group2projc.Huishoud

import junit.framework.TestCase.assertEquals
import junit.framework.TestCase.assertFalse
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
	fun Test1() {
		assertEquals(1+5,2)
	}

	@Test
	fun Test2(){
		assertFalse(2 == 2)
	}

}
