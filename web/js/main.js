async function solution(userid, conversation_id, isDeepThinking, isSearch, query, fileType, fileId) {
    var cid = ''
    if (conversation_id) {
        cid = conversation_id;
    }
    var data = {
        'inputs': {
            'sikao': isDeepThinking ? "打开深度思考" : '关闭深度思考',
            'lianwang': isSearch ? "打开联网搜索" : '关闭联网搜索',
        },
        'query': query,
        'response_mode': 'streaming',
        'conversation_id': cid,
        'user': userid,
        'auto_generate_name': true,
    }
    if (fileType && fileId) {
        data['files'] = [
            {
                'type': fileType,
                'transfer_method': 'local_file',
                "upload_file_id": fileId
            }
        ]
    }
    console.log(data);
    const response = await fetch('http://192.168.42.14:9000/v1/chat-messages', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer app-74Z98SoaD00TYFpwbbzDCduY',
        },
        body: JSON.stringify(data)
    })

    // 获取可读流
    const reader = response.body?.getReader()
    if (!reader) return

    // 读取流数据
    while (true) {
        const { done, value } = await reader.read()
        if (done) break
        window.onReceive(done, value);
    }
    window.onReceive(true, []);
}