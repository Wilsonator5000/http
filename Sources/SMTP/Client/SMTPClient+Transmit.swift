import Core
import Transport

private let crlf: Bytes = [.carriageReturn, .newLine]

extension SMTPClient {
    internal func transmit(line: String, terminating: Bool = true) throws {
        try buffer.send(line)
        if terminating { try buffer.send(crlf) }
        try buffer.flush()
    }

    internal func transmit(line: String, terminating: Bool = true, expectingReplyCode: Int) throws {
        try transmit(line: line, terminating: terminating)
        let (code, replies) = try acceptReply()
        guard code == expectingReplyCode else {
            throw SMTPClientError.unexpectedReply(expected: expectingReplyCode, got: code, replies: replies, initiator: line)
        }
    }
}
