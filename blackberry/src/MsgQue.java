/*
 * MsgQue.java
 *
 * © <your company here>, <year>
 * Confidential and proprietary.
 */

/**
 * 
 */
class MsgQue {

	byte[] m_pData;
	int m_dwSize;

	int m_type;

	MsgQue() {

		m_dwSize = 0;
	}

	byte[] bGet_data() {

		return m_pData;

	}

	boolean bPut(int type, byte[] pData, int dwSize) {

		m_pData = null;

		m_pData = new byte[dwSize];

		m_type = type;
		for (int i = 0; i < dwSize; i++) {

			m_pData[i] = 0;
		}

		for (int i = 0; i < dwSize; i++) {

			m_pData[i] = pData[i];
		}

		m_dwSize = dwSize;

		return true;

	}

}
